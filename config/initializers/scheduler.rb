require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

TwitterWorker.start

if Rails.env.production?
  scheduler.every '5m' do
    TwitterWorker.check_new_tasks true
  end

  scheduler.every '30s' do
    TwitterWorker.check_reset
  end

  scheduler.every '15m' do
    TwitterWorker.check_new_followers
  end

  scheduler.every '1m' do
    TwitterWorker.send_reminders
  end
end