class ProfessorRating < ActiveRecord::Base
  GRADES = [
          "A+",
          "A",
          "A-",
          "B+",
          "B",
          "B-",
          "C+",
          "C",
          "C-",
          "D+",
          "D",
          "D-",
          "F",
          "Pass",
          "Fail",
          "Incomplete",
          "Withdraw",
          "prefer not to say",
          "course not yet completed",
          "none"
          ]
  
  validates :professor, :rater, :course_code, :helpfulness, presence: true
  validates :clarity, :easiness, :grade_received, presence: true
  validates :professor_id, uniqueness: { scope: :rater_id, message: "has already been rated" } 
  validates :online_class, :taken_for_credit, :hotness, inclusion: { in: [true, false] }
  validates :attendance_is_mandatory, inclusion: { in: [true, false] }
  
  belongs_to :professor, inverse_of: :professor_ratings
  
  belongs_to :rater,
    class_name: "User",
    foreign_key: :rater_id,
    inverse_of: :professor_ratings
    
  has_many :up_down_votes, as: :votable
  
  def possible_vote(voter_id)
		vote = UpDownVote.where("voter_id = ? AND votable_id = ? AND votable_type = 'professor_rating'",
															  voter_id, self.id)
                                
    return nil if vote.length == 0
    
    return vote.first
  end
  
  def upvotes
    all_votes = self.up_down_votes
    a = all_votes.inject(0) do |accum, vote|
      next if vote.vote_value == -1
      accum + 1
    end
    
    fail
  end
  
  def downvotes
    all_votes = self.up_down_votes
    all_votes.inject(0) do |accum, vote|
      next if vote.vote_value == 1
      accum + 1
    end
  end
end
