require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

TwitterWorker.start

scheduler.every '1m' do
  TwitterWorker.check_new_tasks
end
