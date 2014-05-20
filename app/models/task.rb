class Task < ActiveRecord::Base
  def self.add text, user, offset_in_hours
    text = text.reverse.split('@', 2).reverse.map(&:reverse)
    
    offset = offset_in_hours.to_i * 60

    date = parse_time(text.last, Time.now.utc, offset) if not text[1].nil?
    date ||= Time.now.utc
    
    is_reminder = text[1] != nil and date > Time.now.utc

    Task.create(:text => text.first.strip, :user => user, :is_done => false, :is_reminder => is_reminder, :date => date, :time_offset => offset)
  end

  def self.update id, text
    task = Task.find id

    text = text.reverse.split('@', 2).reverse.map(&:reverse)
    
    date = parse_time(text.last, Time.now.utc, task.time_offset) if not text[1].nil?
    date ||= Time.now.utc

    is_reminder = text[1] != nil and date > Time.now.utc

    task.text = text.first.strip
    task.date = date
    task.is_reminder = is_reminder
    task.save!

    task
  end

  private

  def self.parse_time string, now, time_offset
    date_hash = {}

    string.split(/[^dwmDWM0-9]/).each do |d|
      date_hash['minute'] = d.to_i         if d =~ /^[0-9]+$/ and date_hash.has_key? 'hour'
      date_hash['hour']   = d.to_i         if d =~ /^[0-9]+$/ and not date_hash.has_key? 'hour'
      date_hash['day']    = d[0...-1].to_i if d =~ /^[0-9]+[dD]$/
      date_hash['week']   = d[0...-1].to_i if d =~ /^[0-9]+[wW]$/
      date_hash['month']  = d[0...-1].to_i if d =~ /^[0-9]+[mM]$/
    end

    return now if date_hash.empty?

    date_hash['minute'] ||= (date_hash.has_key?('hour') ? 0 : now.min)
    date_hash['hour']   ||= now.hour
    date_hash['minute'] = 59 if date_hash['minute'] > 59
    date_hash['hour']   = 23 if date_hash['hour'] > 23

    date = Time.utc now.year, now.month, now.day, date_hash['hour'], date_hash['minute']
    date += time_offset

    date += date_hash['day'].days     if date_hash.has_key? 'day'
    date += date_hash['week'].weeks   if date_hash.has_key? 'week'
    date += date_hash['month'].months if date_hash.has_key? 'month'

    date += 1.day if date < now
    date += 1.day if date < now

    date
  end

end
