require 'spec_helper'

describe TasksController do

  describe "#index" do
    before :each, populate: true do
      user = User.create twitter_alias: 'mr_anderson'
      @task1 = Task.create! :text => 'first reminder', :user => 'mr_anderson'
      @task2 = Task.create! :text => 'second reminder', :user => 'mr_anderson'
      session[:user_id] = user.id
    end

    it "should render" do
      get :index
      expect(response).to be_success
    end

    it "should populate task list", populate: :true do
      get :index
      expect(assigns(:task_list)).to eq([@task2, @task1])
    end
  end


  describe "#add" do
    before :each do
      user = User.create twitter_alias: 'mr_anderson'
      session[:user_id] = user.id
    end

    it "redirects to root" do
      post :add, :task => {'text' => "text of new entry"}
      expect(response).to redirect_to(root_url)
    end

    it "creates new task" do
      expect {
        post(:add, :task => {'text' => "text of new entry"})
      }.to change(Task, :count).by 1
    end
  end


  describe "#destroy" do
    before :each do
      user = User.create twitter_alias: 'mr_anderson'
      @task = Task.create :text => "This task will be removed.", :user => 'mr_anderson'
      session[:user_id] = user.id
    end

    it "destroys a task" do
      expect {
        post(:destroy, :id => @task.id)
      }.to change(Task, :count).by -1
    end
  end
end
