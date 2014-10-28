class UsersController < ApplicationController
  before_filter :require_logged_in, only: [:show, :edit, :update]
  before_filter :require_logged_out, only: [:new, :create]

  def new
    @user = User.new()

    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notices] = ["User created!"]
      login_user(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])

    render :show
  end

  def edit
    @user = current_user

    render :edit
  end

  def update
    @user = current_user

    if @user.update(user_params)
      flash[:notices] = ["User updated!"]
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
