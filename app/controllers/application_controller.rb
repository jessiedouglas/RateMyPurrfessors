class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by_session_token(session[:token])
  end

  def logged_in?
    !!current_user
  end

  def login_user(user)
    session[:token] = user.reset_session_token!
  end

  def logout_user
    session[:token] = nil
  end

  def require_logged_in
    unless logged_in?
      flash[:errors] = ["Must be logged in to do that"]
      redirect_to new_session_url
    end
  end

  def require_logged_out
    if logged_in?
      flash[:errors] = ["Must be logged in to do that"]
      redirect_to user_url(current_user)
    end
  end
end
