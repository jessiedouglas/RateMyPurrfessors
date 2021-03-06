class Api::CollegeRatingsController < ApplicationController
  before_filter :require_logged_in, except: :show
  before_filter :require_same_user, only: [:update, :destroy]
  
  def index
    render json: CollegeRating.select("id")
  end
  
  def show
    @rating = CollegeRating.find(params[:id])
    
    render :form
  end
  
  def create
    @rating = current_user.college_ratings.new(college_rating_params)
    
    if @rating.save
      render json: @rating
    else
      render json: @rating.errors.full_messages
    end
  end
  
  def update
    @rating = CollegeRating.find(params[:id])
    
    if @rating.update(college_rating_params)
      render json: @rating
    else
      render json: @rating.errors.full_messages
    end
  end
  
  def destroy
    @rating = CollegeRating.find(params[:id])
    @rating.destroy!
    
    render json: {}
  end
  
  private
  def require_logged_in
    unless logged_in?
      flash[:errors] = ["Must be logged in to create, edit, or delete ratings"]
      redirect_to "#" + new_session_path
    end
  end
  
  def require_same_user
    rating = CollegeRating.find(params[:id])
    
    if current_user.id != rating.rater_id
      flash[:errors] = ["You may not edit or destroy another user's rating."]
      redirect_to "#" + user_path(current_user)
    end
  end
  
  def college_rating_params
    params.require(:college_rating).permit(
                                            :college_id,
                                            :reputation,
                                            :location,
                                            :opportunities,
                                            :library,
                                            :grounds_and_common_areas,
                                            :internet,
                                            :food,
                                            :clubs,
                                            :social,
                                            :happiness,
                                            :graduation_year,
                                            :comments
                                            )
  end
end
