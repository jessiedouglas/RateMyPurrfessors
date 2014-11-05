class Api::CollegeRatingsController < ApplicationController
  before_filter :require_logged_in
  before_filter :require_same_user, only: [:edit, :update, :destroy]
  
  def show
    @rating = CollegeRating.find(params[:id])
    
    render :form
  end
  
  def create
    @rating = current_user.college_ratings.new(college_rating_params)
    
    if @rating.save
      flash[:notices] = ["Rating saved!"]
      redirect_to root_url + "#" + college_path(@rating.college_id)
    else
      flash[:errors] = @rating.errors.full_messages
      redirect_to root_url + "#" + new_college_college_rating_path(@rating.college_id)
    end
  end
  
  def update
    @rating = CollegeRating.find(params[:id])
    
    if @rating.update(college_rating_params)
      flash[:notices] = ["Rating updated!"]
      redirect_to root_url + "#" + college_path(@rating.college_id)
    else
      flash[:errors] = @rating.errors.full_messages
      redirect_to root_url + "#" + edit_college_rating_path(@rating)
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
