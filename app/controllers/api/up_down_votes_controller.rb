class Api::UpDownVotesController < ApplicationController
  before_filter :require_logged_in, except: :find_vote
  before_filter :require_different_user, only: :create
  before_filter :require_same_user, only: :destroy
  
  def create
    @vote = UpDownVote.new(vote_params.merge(voter_id: current_user.id))
    type = params[:up_down_vote][:votable_type]
    id = params[:up_down_vote][:votable_id]
    p type, id
    
    if type == "professor_rating"
      votable = ProfessorRating.find(id)
    else
      votable = CollegeRating.find(id)
    end
    
    @vote.votable = votable
    
    if @vote.save
      flash[:notices] = ["Vote registered!"]
    else
      flash[:errors] = @vote.errors.full_messages
    end
    
    render json: @vote
  end
  
  def find_vote
    id = params[:up_down_vote][:votable_id]
    type = params[:up_down_vote][:votable_type].camelize
    @vote = UpDownVote.where("votable_id = ? AND votable_type = ? AND voter_id = ?", id, type, current_user.id).first
    
    render json: @vote
  end
  
  def destroy
    @vote = UpDownVote.find(params[:id])
    @vote.destroy!
    
    render json: {}
  end
  
  private
  def vote_params
    params.require(:up_down_vote).permit(:vote_value)
  end
  
  def require_logged_in
    unless logged_in?
      flash[:errors] = ["Must be logged in to create, edit, or delete ratings"]
      redirect_to root_url + "#" + new_session_path
    end
  end
  
  def redirect(type, id)
    if type == "CollegeRating"
      rating = CollegeRating.find(id)
      redirect_to root_url + "#" + college_path(rating.college_id)
    else
      rating = ProfessorRating.find(id)
      redirect_to root_url + "#" + professor_path(rating.professor_id)
    end
  end
  
  def require_different_user
    if current_user.id == params[:rater_id].to_i
      flash[:errors] = ["You can't vote on your own post!"]
      redirect(params[:up_down_vote][:votable_type], params[:up_down_vote][:votable_id])
    end
  end
  
  def require_same_user
    @vote = UpDownVote.find(params[:id])
    unless current_user.id == @vote.voter_id
      flash[:errors] = ["You can't delete others' votes!"]
      redirect(params[:up_down_vote][:votable_type], params[:up_down_vote][:votable_id])
    end
  end
end
