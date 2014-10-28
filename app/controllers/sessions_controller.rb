class SessionsController < ApplicationController
  before_filter :require_logged_in, only: :destroy
  before_filter :require_logged_out, except: :destroy

  def new
    @user = User.new

    render :new
  end

  def create
    email = params[:user][:email]
    password = params[:user][:password]
    @user = User.find_by_credentials(email, password)

    if @user
      login_user(@user)
      redirect_to user_url(@user)
    else
      @user = User.new
      flash.now[:errors] = ["Incorrect email/password combination"]
      render :new
    end
  end

  def destroy
    logout_user

    redirect_to new_session_url
  end
end
