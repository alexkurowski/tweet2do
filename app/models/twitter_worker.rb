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

  def self.check_new_tasks
    p 'check_new_tasks...'

    processed = []
    @@client.direct_messages_received.each do |message| # array of last 20 messages
      processed << message.id
      process @@client.direct_message(message.id)
    end

    @@client.destroy_direct_message processed if not processed.empty?
  end

  private 

  def self.process message
    task = Task.add({'text' => message.text}, message.sender.username)
  end
end
