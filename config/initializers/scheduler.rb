require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

TwitterWorker.start

scheduler.every '2m' do
  TwitterWorker.check_new_tasks true
end

scheduler.every '30s' do
  TwitterWorker.check_reset
end

scheduler.every '15m' do
  TwitterWorker.check_new_followers
end

scheduler.every '5m' do
  TwitterWorker.send_reminders
end