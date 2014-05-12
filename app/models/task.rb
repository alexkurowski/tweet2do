class Task < ActiveRecord::Base
  def self.add task, user
    if task['date(1i)']
      Task.create(:text => task['text'], :user => user, :date => DateTime.civil_from_format(:local, task['date(1i)'].to_i, task['date(2i)'].to_i, task['date(3i)'].to_i, task['date(4i)'].to_i, task['date(5i)'].to_i))
    else
      Task.create(:text => task['text'], :user => user, :date => DateTime.now)
    end
  end
end
