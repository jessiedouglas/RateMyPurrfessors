class UpDownVotesController < ApplicationController
  before_filter :require_logged_in
  before_filter :require_different_user, only: :create
  before_filter :require_same_user, only: :destroy
  
  def create
    @vote = UpDownVote.new(vote_params.merge(voter_id: current_user.id))
    
    if @vote.save
      flash[:notices] = ["Vote registered!"]
    else
      flash[:errors] = @vote.errors.full_messages
    end
    
    redirect(@vote.votable_type, @vote.votable_id)
  end
  
  def destroy
    @vote = UpDownVote.find(params[:id])
    type = @vote.votable_type
    id = @vote.votable_id
    @vote.destroy!
    
    redirect(type, id)
  end
  
  private
  def vote_params
    params.require(:up_down_vote).permit(:votable_id, :votable_type, :vote_value)
  end
  
  def redirect(type, id)
    if type == "college_rating"
      redirect_to college_url(id)
    else
      redirect_to professor_url(id)
    end
  end
  
  def require_different_user
    if current_user.id == params[:rater_id]
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
