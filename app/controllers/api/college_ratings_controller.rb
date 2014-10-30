class Api::CollegeRatingsController < ApplicationController
  before_filter :require_logged_in
  before_filter :require_same_user, only: [:edit, :update, :destroy]
  
  def new
    @rating = current_user.college_ratings.new
    @college = College.find(params[:college_id])
    @grad_years = CollegeRating.grad_years
    
    render :new
  end
  
  def create
    @rating = current_user.college_ratings.new(college_rating_params)
    
    if @rating.save
      flash[:notices] = ["Rating saved!"]
      redirect_to api_college_url(@rating.college_id)
    else
      @college = College.find(params[:college_id])
      @grad_years = CollegeRating.grad_years
      flash[:errors] = @rating.errors.full_messages
      render :new
    end
  end
  
  def edit
    @rating = CollegeRating.find(params[:id])
    @college = @rating.college
    @grad_years = CollegeRating.grad_years
    
    render :edit
  end
  
  def update
    @rating = CollegeRating.find(params[:id])
    
    if @rating.update(college_rating_params)
      flash[:notices] = ["Rating updated!"]
      redirect_to api_college_url(@rating.college_id)
    else
      @college = @rating.college
      @grad_years = CollegeRating.grad_years
      flash[:errors] = @rating.errors.full_messages
      render :edit
    end
  end
  
  def destroy
    @rating = CollegeRating.find(params[:id])
    @rating.destroy!
    flash[:notices] = ["Rating deleted."]
    
    redirect_to user_url(current_user)
  end
  
  private
  
  def require_same_user
    rating = CollegeRating.find(params[:id])
    
    if current_user.id != rating.rater_id
      flash[:errors] = ["You may not edit or destroy another user's rating."]
      redirect_to user_url(current_user)
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
