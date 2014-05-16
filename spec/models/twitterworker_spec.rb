require 'spec_helper'

describe TwitterWorker do
  it "should start" do
    return_value = TwitterWorker.start
    expect(return_value).to be_instance_of Twitter::REST::Client
  end
end
