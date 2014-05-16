require 'spec_helper'

describe Task do
  it "should be created with reminder date" do
    now = Time.now
    now.change :hour => 16, :min => 30, :sec => 0
    now += 2.days

    task = Task.add 'text of the reminder @2d-16.30', 'mr_anderson'

    expect(task.text).to eq('text of the reminder')
    expect(task.is_reminder).to eq(true)
    expect(task.date).to eq(date)
  end
end
