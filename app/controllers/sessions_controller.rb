class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid auth["provider"], auth["uid"]
    user = User.create_omni auth if user.nil?
    session[:user_id] = user.id

    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_url
  end
end