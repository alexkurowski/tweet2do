class Task < ActiveRecord::Base
  def self.add task, user
    text = task.split '@'
    text[0] = text[0..-2].join if text.count > 2
    text[1] = "" if text.count < 2

    is_reminder = false
    now = Time.now
    date = parse_time text.last, now
    is_reminder = true if not text.last.empty? and date > now

    Task.create(:text => text.first.strip, :user => user, :is_done => false, :is_reminder => is_reminder, :date => date.utc)
  end

  def self.update id, text
    task = Task.where(id: id).take

    text = text.split '@'
    text[0] = text[0..-2].join if text.count > 2
    text[1] = "" if text.count < 2

    is_reminder = false
    now = Time.now
    date = parse_time text.last, now
    is_reminder = true if not text.last.empty? and date > now

    task.text = text.first.strip
    task.date = date.utc
    task.is_reminder = is_reminder
    task.save!

    task
  end

  private

  def self.parse_time string, now
    date_hash = {}

    string.split(/[^dwm0-9]/).each do |d|
      date_hash['minute'] = d.to_i if d =~ /^[0-9]+$/ and date_hash.has_key? 'hour'
      date_hash['hour']   = d.to_i if d =~ /^[0-9]+$/ and not date_hash.has_key? 'hour'
      date_hash['day']    = d[0...-1].to_i if d =~ /^[0-9]+[dD]$/
      date_hash['week']   = d[0...-1].to_i if d =~ /^[0-9]+[wW]$/
      date_hash['month']  = d[0...-1].to_i if d =~ /^[0-9]+[mM]$/
    end

    date_hash['minute'] ||= (date_hash.has_key?('hour') ? 0 : now.min)
    date_hash['hour'] ||= now.hour
    date_hash['minute'] = 59 if date_hash['minute'] > 59
    date_hash['hour'] = 23 if date_hash['hour'] > 23

    date = Time.local now.year, now.month, now.day, date_hash['hour'], date_hash['minute'], now.sec

    date += date_hash['day'].days     if date_hash.has_key? 'day'
    date += date_hash['week'].weeks   if date_hash.has_key? 'week'
    date += date_hash['month'].months if date_hash.has_key? 'month'

    date += 1.day if date < now and not date_hash.empty?

    date
  end

end
