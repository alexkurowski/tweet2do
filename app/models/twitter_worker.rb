class TwitterWorker < ActiveRecord::Base
  def self.start
    config = {
      :consumer_key        => "7GGByLqHYOv7FtxFsWldv8CY7",
      :consumer_secret     => "6j7knVk57fyjS4RIt8rIUZdPNbmYcGK1cWJte6IkYqQ6VuCP85",
      :access_token        => "1552533662-otqd46hk75stoHmD9oP5E7ugpIdt6S5RkcOdQ0h",
      :access_token_secret => "k3AKilRA19oMtmLF2zrJYrV3OiwVPbb2iSQTRRiNlAbVp"
    }

    @@client ||= Twitter::REST::Client.new config
  end

  def self.check_new_followers
    start if @@client.nil?
    
    followers = @@client.follower_ids("zneue").map{|_|_}

    friends = @@client.friend_ids("zneue").map{|_|_}

    @@client.follow followers - friends
  end

  def self.check_new_tasks
    start if @@client.nil?
    
    processed = []
    @@client.direct_messages_received.each do |message|
      processed << message.id
      process @@client.direct_message(message.id)
    end

    @@client.destroy_direct_message processed if not processed.empty?
  end

  def self.send_reminders
    start if @@client.nil?

    tasks = Task.where(is_reminder: true).to_a
    now = Time.now.utc

    tasks.each do |task|
      if now >= task.date
        @@client.create_direct_message task.user, task.text
        task.is_reminder = false
        task.save!
      end
    end
  end

  private 

  def self.process message
    task = Task.add({'text' => message.text}, message.sender.username)
  end
end
