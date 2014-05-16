require 'spec_helper'

describe TwitterWorker do
  it "should start" do
    return_value = TwitterWorker.start
    expect(return_value).to be_instance_of Twitter::REST::Client
  end

  it "should check new followers" do
    # expect(TwitterWorker.check_new_followers).not_to eq(:error)
  end

  it "should check new tasks" do
    # expect(TwitterWorker.check_new_tasks).not_to eq(:error)
  end
end
