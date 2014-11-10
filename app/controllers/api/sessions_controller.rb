class Api::SessionsController < ApplicationController
  before_filter :require_logged_out

  def create
    email = params[:user][:email]
    password = params[:user][:password]
    @user = User.find_by_credentials(email, password)
    
    if @user
      login_user(@user)
      render json: @user
    else
      render json: ["Incorrect email/password combination"]
    end
  end

  private
  def require_logged_out
    redirect_to "#" + user_path(current_user) if logged_in?
  end
end
