class Task < ActiveRecord::Base
  def self.add task, user, time_offset
    text = task.split '@'
    text[0] = text[0..-2].join if text.count > 2
    text[1] = "" if text.count < 2
    time_offset = time_offset.to_i * 60

    is_reminder = false
    now = Time.now.utc
    date = parse_time text.last, now, time_offset
    is_reminder = true if not text.last.empty? and date > now
    
    Task.create(:text => text.first.strip, :user => user, :is_done => false, :is_reminder => is_reminder, :date => date, :time_offset => time_offset)
  end

  def self.update id, text
    task = Task.find id

    text = text.split '@'
    text[0] = text[0..-2].join if text.count > 2
    text[1] = "" if text.count < 2

    is_reminder = false
    now = Time.now.utc
    date = parse_time text.last, now, task.time_offset
    is_reminder = true if not text.last.empty? and date > now

    task.text = text.first.strip
    task.date = date
    task.is_reminder = is_reminder
    task.save!

    task
  end

  private

  def self.parse_time string, now, time_offset
    date_hash = {}

    string.split(/[^dwm0-9]/).each do |d|
      date_hash['minute'] = d.to_i if d =~ /^[0-9]+$/ and date_hash.has_key? 'hour'
      date_hash['hour']   = d.to_i if d =~ /^[0-9]+$/ and not date_hash.has_key? 'hour'
      date_hash['day']    = d[0...-1].to_i if d =~ /^[0-9]+[dD]$/
      date_hash['week']   = d[0...-1].to_i if d =~ /^[0-9]+[wW]$/
      date_hash['month']  = d[0...-1].to_i if d =~ /^[0-9]+[mM]$/
    end

    return now if date_hash.empty?

    date_hash['minute'] ||= (date_hash.has_key?('hour') ? 0 : now.min)
    date_hash['hour'] ||= now.hour
    date_hash['minute'] = 59 if date_hash['minute'] > 59
    date_hash['hour'] = 23 if date_hash['hour'] > 23

    date = Time.utc now.year, now.month, now.day, date_hash['hour'], date_hash['minute'], now.sec
    date += time_offset

    date += date_hash['day'].days     if date_hash.has_key? 'day'
    date += date_hash['week'].weeks   if date_hash.has_key? 'week'
    date += date_hash['month'].months if date_hash.has_key? 'month'

    date += 1.day if date < now
    date += 1.day if date < now

    date
  end

end
