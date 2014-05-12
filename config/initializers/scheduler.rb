require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

TwitterWorker.start

scheduler.every '1m' do
  TwitterWorker.check_new_tasks
end

scheduler.every '15m' do
  TwitterWorker.check_new_followers
end

scheduler.every '5m' do
  TwitterWorker.send_reminders
end