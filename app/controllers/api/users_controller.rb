class Api::UsersController < ApplicationController
  before_filter :require_logged_in, only: [:show, :update]
  before_filter :require_logged_out, only: :create

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notices] = ["User created!"]
      login_user(@user)
      
      redirect_to root_url + "#" + user_path(current_user)
    else
      flash.now[:errors] = @user.errors.full_messages
      redirect_to root_url + "#" + new_user_path
    end
  end

  def show
    @user = User.find(params[:id])
    
    if @user.college_id
      @college = @user.college
    end
    @all_ratings = @user.all_ratings

    render :show
  end

  def update
    @user = current_user

    if @user.update(user_params)
      render json: {}
    else
      flash.now[:errors] = @user.errors.full_messages
      render json: {}
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :college_id)
  end
  
  def require_logged_in
    redirect_to root_url + "#" + new_session_path unless logged_in?
  end
  
  def require_logged_out
    redirect_to root_url + "#" + user_path(current_user) if logged_in?
  end
end
