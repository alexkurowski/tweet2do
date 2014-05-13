class TasksController < ApplicationController
  helper_method :current_user

  def index
    @signed = true if session[:user_id]

    TwitterWorker.check_new_tasks
    
    @task_list = Task.where(user: current_user.twitter_alias).sort_by(&:id).reverse if @signed
    @task_list ||= []

    @new_task = Task.new
  end

  def add
    Task.add params[:task], current_user.twitter_alias
    redirect_to root_url
  end

  def destroy
    @task = Task.where(id: params[:id]).take
    @task.destroy if @task.user == current_user.twitter_alias
    redirect_to root_url
  end

  private
  
  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
  end
end
