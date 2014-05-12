require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1m' do
	TwitterWorker.check_for_new_tasks
end

scheduler.join