class TasksController < ApplicationController
  helper_method :current_user

  def index
    @signed = true if session[:user_id]
    
    @task_list = Task.find_all_by_user current_user.twitter_alias if @signed
    @task_list ||= []

    @new_task = Task.new
  end

  def add
    Task.add params[:task], current_user.twitter_alias
    redirect_to root_url
  end

  private
  
  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
  end
end
