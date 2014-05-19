require 'spec_helper'

describe Task do
  it "should create new task with reminder date" do
    task = Task.add 'text of the reminder @2d-08.30', 'mr_anderson', -6 * 60

    date = Time.now.utc
    date = Time.utc date.year, date.month, date.day, 8, 30, date.sec
    date -= 6.hours
    date += 2.days

    expect(task.text).to eq('text of the reminder')
    expect(task.user).to eq('mr_anderson')
    expect(task.is_reminder).to eq(true)
    expect(task.date).to be_within(1.minute).of(date)
  end

  it "should create new task without reminder and strip whitespaces" do
    task = Task.add ' simple todo entry ', 'putin', -4

    expect(task.text).to eq('simple todo entry')
    expect(task.user).to eq('putin')
    expect(task.is_reminder).to eq(false)
  end

  it "should update task with new date" do
    task = Task.add 'Buy one carton of milk, and if they have eggs, get six.', 'homer_simpson', 5 * 60

    expect(task.is_reminder).to eq(false)

    task = Task.update task.id, 'Buy one carton of milk, and if they have eggs, get six eggs. @1d-16.45'

    date = Time.now.utc
    date = Time.utc date.year, date.month, date.day, 16, 45, date.sec
    date += 5.hours
    date += 1.day

    expect(task.text).to eq('Buy one carton of milk, and if they have eggs, get six eggs.')
    expect(task.is_reminder).to eq(true)
    expect(task.date).to be_within(1.minute).of(date)
  end

  it "should parse time" do
    date = Task.parse_time "1d-20.30", Time.now.utc, 4
    expect(date.day).to eq((Time.now.utc + 1.day).day)
    expect(date.hour).to eq(20)
    expect(date.min).to be_within(1.minute).of(30)

    date = Task.parse_time "1w-02", Time.now.utc, 4
    expect(date.day).to eq((Time.now.utc + 7.days).day)
    expect(date.hour).to eq(2)
    expect(date.min).to be_within(1.minute).of(0)

    date = Task.parse_time "2m-11.10", Time.now.utc, -6
    expect(date.month).to eq((Time.now.utc + 2.month).month)
    expect(date.hour).to eq(11)
    expect(date.min).to be_within(1.minute).of(10)

    date = Task.parse_time "60.80", Time.now.utc, -2
    expect(date.hour).to eq(23)
    expect(date.min).to be_within(1.minute).of(59)
  end
end
