class Api::ProfessorRatingsController < ApplicationController
  before_filter :require_logged_in, except: :show
  before_filter :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    render json: ProfessorRating.select("id")
  end
  
  def show
    @rating = ProfessorRating.find(params[:id])
    
    render :form
  end
  
  def create
    @rating = current_user.professor_ratings.new(professor_rating_params)
    
    if @rating.save
      flash[:notices] = ["Rating saved!"]
      redirect_to root_url + "#" + professor_path(@rating.professor_id)
    else
      flash[:errors] = @rating.errors.full_messages
      redirect_to root_url + "#" + new_professor_professor_rating_path(@rating.professor_id)
    end
  end
  
  def update
    @rating = ProfessorRating.find(params[:id])
    
    if @rating.update(professor_rating_params)
      flash[:notices] = ["Rating updated!"]
      redirect_to root_url + "#" + professor_path(@rating.professor_id)
    else
      flash[:errors] = @rating.errors.full_messages
      redirect_to root_url + "#" + edit_professor_rating_path(@rating)
    end
  end
  
  def destroy
    @rating = ProfessorRating.find(params[:id])
    @rating.destroy!
    flash[:notices] = ["Rating deleted."]
    
    render json: {}
  end
  
  private
  def require_logged_in
    unless logged_in?
      flash[:errors] = ["Must be logged in to create, edit, or delete ratings"]
      redirect_to root_url + "#" + new_session_path
    end
  end
  
  def require_same_user
    rating = ProfessorRating.find(params[:id])
    
    if current_user.id != rating.rater_id
      flash[:errors] = ["You may not edit or destroy another user's rating."]
      redirect_to root_url + "#" + user_path(current_user)
    end
  end
  
  def professor_rating_params
    params.require(:professor_rating).permit(
                                            :professor_id,
                                            :course_code,
                                            :online_class,
                                            :helpfulness,
                                            :clarity,
                                            :easiness,
                                            :taken_for_credit,
                                            :hotness,
                                            :comments,
                                            :attendance_is_mandatory,
                                            :interest,
                                            :textbook_use,
                                            :grade_received
                                            )
  end
end
