class TwitterWorker < ActiveRecord::Base
  class << self
    attr_accessor :client, :check_allowed
  end

  def self.start
    config = {
      :consumer_key        => "6JBqCTxZbOO85nFqKOZUpKTcX",
      :consumer_secret     => "gAleiufup28QgtJtRC8enbMp8qcgKf176A9WeC30jZ3pAkeIEp",
      :access_token        => "2499780018-niiMIqFz7wNvJ5JTZhLFlRRuXFPmnbYGzZ7M1CI",
      :access_token_secret => "ZPvFgq3H6vGHQrLq2ONnyaPOrDCZs8Vc5kZeuglIUjSE6"
    }

    @check_allowed = true
    @client ||= Twitter::REST::Client.new config
  end

  def self.check_new_followers
    start if @client.nil?
    
    begin
      followers = @client.follower_ids("actrem").map{|_|_}

      friends = @client.friend_ids("actrem").map{|_|_}

      @client.follow followers - friends
    rescue
      puts "Error accessing twitter (most likely rate limit error)"

      :error
    end
  end

  def self.check_reset
    @check_allowed = true
  end

  def self.check_new_tasks scheduled = false
    start if @client.nil?
    
    begin
      if @check_allowed or scheduled
        processed = []
        @client.direct_messages_received.each do |message|
          processed << message.id
          process @client.direct_message(message.id)
        end

        @client.destroy_direct_message processed if not processed.empty?
      end

      @check_allowed = false
    rescue
      puts "Error accessing twitter (most likely rate limit error)"

      :error
    end
  end

  def self.send_reminders
    start if @client.nil?

    tasks = Task.where(is_reminder: true).to_a
    now = Time.now.utc

    tasks.each do |task|
      if now >= task.date and task.is_reminder and not task.is_done
        @client.create_direct_message task.user, task.text
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
