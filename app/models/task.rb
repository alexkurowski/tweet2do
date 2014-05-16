class Task < ActiveRecord::Base
  def self.add task, user
    text = task.split '@'
    text[0] = text[0..-2].join if text.count > 2
    text[1] = "" if text.count < 2

    is_reminder = false
    now = Time.now
    date = parse_time text.last, now
    is_reminder = true if date > now

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
    is_reminder = true if date > now.utc

    task.text = text.first
    task.date = date.utc
    task.is_reminder = is_reminder
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts "date = #{date}"
    puts "now = #{now}"
    puts "date - 60 > now = #{date > now}"
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    task.save!
  end

  def self.parse_time string, now
    date_hash = {}

    string.split(/[^dwm0-9]/).each do |d|
      date_hash['month']  = d[0...-1].to_i if d =~ /^[0-9]+[mM]$/
      date_hash['week']   = d[0...-1].to_i if d =~ /^[0-9]+[wW]$/
      date_hash['day']    = d[0...-1].to_i if d =~ /^[0-9]+[dD]$/
      date_hash['hour']   = d.to_i if d =~ /^[0-9]+$/ and not date_hash.has_key? 'hour'
      date_hash['minute'] = d.to_i if d =~ /^[0-9]+$/ and date_hash.has_key? 'hour'
    end

    date_hash['hour'] ||= now.hour
    date_hash['minute'] ||= now.min
    date_hash['hour'] = 23 if date_hash['hour'] > 23
    date_hash['minute'] = 59 if date_hash['minute'] > 59

    date = Time.local now.year, now.month, now.day, date_hash['hour'], date_hash['minute'], now.sec

    date += date_hash['day'].days     if date_hash.has_key? 'day'
    date += date_hash['week'].weeks   if date_hash.has_key? 'week'
    date += date_hash['month'].months if date_hash.has_key? 'month'

    date += 1.day if date+60 < now and not date_hash.empty?

    date
  end

end
