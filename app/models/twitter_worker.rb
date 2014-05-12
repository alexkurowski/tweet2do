class TwitterWorker < ActiveRecord::Base
	def self.check_for_new_tasks
		puts 'twitter worker: hi'
	end
end
