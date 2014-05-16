require 'spec_helper'

describe User do
  it 'should be created' do
    auth = {
              "provider" => 'twitter',
              "uid" => '123456789',
              "info" => {
                          "name" => 'Mr. Anderson',
                          "nickname" => 'mr_anderson',
                          "image" => 'http://i.imgur.com/1J3hy.jpg'
                        }
           }
    user = User.create_omni auth

    expect(user.provider).to eq(auth['provider'])
    expect(user.uid).to eq(auth['uid'])
    expect(user.name).to eq(auth['info']['name'])
    expect(user.twitter_alias).to eq(auth['info']['nickname'])
    expect(user.image).to eq(auth['info']['image'])
  end
end
