class ProfessorRatingsController < ApplicationController
  before_filter :require_logged_in
  before_filter :require_same_user, only: [:edit, :update, :destroy]
  
  def new
    @rating = current_user.professor_ratings.new
    @professor = Professor.find(params[:professor_id])
    @grades = ProfessorRating::GRADES
    
    render :form
  end
  
  def create
    @rating = current_user.professor_ratings.new(professor_rating_params)
    
    if @rating.save
      flash[:notices] = ["Rating saved!"]
      redirect_to professor_url(@rating.professor_id)
    else
      @professor = Professor.find(params[:professor_id])
      @grades = ProfessorRating::GRADES
      flash[:errors] = @rating.errors.full_messages
      render :form
    end
  end
  
  def edit
    @rating = ProfessorRating.find(params[:id])
    @professor = @rating.professor
    @grades = ProfessorRating::GRADES
    
    render :form
  end
  
  def update
    @rating = ProfessorRating.find(params[:id])
    
    if @rating.update(professor_rating_params)
      flash[:notices] = ["Rating updated!"]
      redirect_to professor_url(@rating.professor_id)
    else
      @professor = @rating.professor
      @grades = ProfessorRating::GRADES
      flash[:errors] = @rating.errors.full_messages
      render :form
    end
  end
  
  def destroy
    @rating = ProfessorRating.find(params[:id])
    @rating.destroy!
    flash[:notices] = ["Rating deleted."]
    
    redirect_to user_url(current_user)
  end
  
  private
  
  def require_same_user
    rating = ProfessorRating.find(params[:id])
    
    if current_user.id != rating.rater_id
      flash[:errors] = ["You may not edit or destroy another user's rating."]
      redirect_to user_url(current_user)
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
