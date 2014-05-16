require 'spec_helper'

describe Task do
  it "should create new task with reminder date" do
    task = Task.add 'text of the reminder @2d-08.30', 'mr_anderson'

    date = Time.now
    date = Time.local date.year, date.month, date.day, 8, 30, date.sec
    date += 2.days

    expect(task.text).to eq('text of the reminder')
    expect(task.user).to eq('mr_anderson')
    expect(task.is_reminder).to eq(true)
    expect(task.date).to be_within(1.minute).of(date.utc)
  end

  it "should create new task without reminder and strip whitespaces" do
    task = Task.add ' simple todo entry ', 'putin'

    expect(task.text).to eq('simple todo entry')
    expect(task.user).to eq('putin')
    expect(task.is_reminder).to eq(false)
  end

  it "should update task with new date" do
    task = Task.add 'Buy one carton of milk, and if they have eggs, get six.', 'homer_simpson'

    expect(task.is_reminder).to eq(false)

    task = Task.update task.id, 'Buy one carton of milk, and if they have eggs, get six eggs. @1d-16.45'

    date = Time.now
    date = Time.local date.year, date.month, date.day, 16, 45, date.sec
    date += 1.day

    expect(task.text).to eq('Buy one carton of milk, and if they have eggs, get six eggs.')
    expect(task.is_reminder).to eq(true)
    expect(task.date).to be_within(1.minute).of(date.utc)
  end

  it "should parse time" do
    date = Task.parse_time "1d-20.30", Time.now

    expect(date.day).to eq((Time.now + 1.day).day)
    expect(date.hour).to eq(20)
    expect(date.min).to eq(30)
  end
end
