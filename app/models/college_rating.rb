class CollegeRating < ActiveRecord::Base
  validates :college, :rater, :reputation, :location, :opportunities, presence: true
  validates :library, :grounds_and_common_areas, :internet, :food, presence: true
  validates :clubs, :social, :happiness, presence: true
  validates :college_id, uniqueness: { scope: :rater_id, message: "has already been rated" }
  
  belongs_to :college, inverse_of: :college_ratings
  
  belongs_to :rater,
    class_name: "User",
    foreign_key: :rater_id,
    inverse_of: :college_ratings
    
  has_many :up_down_votes, as: :votable, dependent: :destroy
  
  paginates_per 10
    
  def self.grad_years
    this_year = Date.today.year
    start_year = this_year - 25
    end_year = this_year + 5
    
    (start_year..end_year).to_a.reverse
  end
  
  def possible_vote(voter_id)
		vote = UpDownVote.where("voter_id = ? AND votable_id = ? AND votable_type = 'CollegeRating'",
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
    
    a || 0
  end
  
  def downvotes
    all_votes = self.up_down_votes
    a = all_votes.inject(0) do |accum, vote|
      next if vote.vote_value == 1
      accum + 1
    end
    
    a || 0
  end
end
