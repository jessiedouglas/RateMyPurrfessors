class Api::UsersController < ApplicationController
  before_filter :require_logged_in, only: [:show, :update]
  before_filter :require_logged_out, only: :create

  def create
    @user = User.new(user_params)

    if @user.save
      login_user(@user)
      render json: @user
    else
      render json: @user.errors.full_messages
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
    redirect_to "#" + new_session_path unless logged_in?
  end
  
  def require_logged_out
    redirect_to "#" + user_path(current_user) if logged_in?
  end
end
