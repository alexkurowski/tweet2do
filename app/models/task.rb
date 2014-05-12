class Task < ActiveRecord::Base
  def self.add task, user
    text = task['text'].split '@'
    text[0] = text[0..-2].join if text.count > 2
    text[1] = "" if text.count < 2

    is_reminder = false
    now = Time.now

    date_hash = {}
    text.last.split(/[^dwm0-9]/).each do |d|
      date_hash['month']  = d[0...-1].to_i if d =~ /^[0-9]+m$/
      date_hash['week']   = d[0...-1].to_i if d =~ /^[0-9]+w$/
      date_hash['day']    = d[0...-1].to_i if d =~ /^[0-9]+d$/
      date_hash['hour']   = d.to_i if d =~ /^[0-9]+$/ and not date_hash.has_key? 'hour'
      date_hash['minute'] = d.to_i if d =~ /^[0-9]+$/ and date_hash.has_key? 'hour'
    end

    is_reminder = true if not date_hash.empty?

    date_hash['hour'] ||= now.hour
    date_hash['minute'] ||= now.min
    date_hash['hour'] = 23 if date_hash['hour'] > 23
    date_hash['minute'] = 59 if date_hash['minute'] > 59
    
    date = Time.local now.year, now.month, now.day, date_hash['hour'], date_hash['minute']

    date += date_hash['day'].days     if date_hash.has_key? 'day'
    date += date_hash['week'].weeks   if date_hash.has_key? 'week'
    date += date_hash['month'].months if date_hash.has_key? 'month'

    date += 1.day if date < Time.now and not date_hash.empty?

    Task.create(:text => text.first, :user => user, :is_done => false, :is_reminder => is_reminder, :date => date.utc)
  end
end
