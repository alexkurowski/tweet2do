class User < ActiveRecord::Base
  def self.create_omni auth
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
      user.twitter_alias = auth["info"]["name"]
    end
  end
end
