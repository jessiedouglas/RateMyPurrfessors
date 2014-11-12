class Api::SessionsController < ApplicationController
  before_filter :require_logged_out, only: [:create]

  def create
    email = params[:user][:email]
    password = params[:user][:password]
    @user = User.find_by_credentials(email, password)
    
    if @user
      login_user(@user)
      render json: @user
    else
      render json: ["Incorrect email/password combination"], status: 422
    end
  end
  
  def destroy
    logout_user

    redirect_to "#" + new_session_path
  end
end
