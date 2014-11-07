class Api::SessionsController < ApplicationController
  before_filter :require_logged_out

  def create
    email = params[:user][:email]
    password = params[:user][:password]
    @user = User.find_by_credentials(email, password)
    
    if @user
      login_user(@user)
      redirect_to "#" + user_path(@user)
    else
      flash.now[:errors] = ["Incorrect email/password combination"]
      redirect_to "#" + new_session_url
    end
  end

  private
  def require_logged_out
    redirect_to "#" + user_path(current_user) if logged_in?
  end
end
