class UpDownVote < ActiveRecord::Base
  validates :voter, :vote_value, :votable_type, :votable_id, presence: true
  validates :vote_value, inclusion: { in: [-1, 1] }
  validates :votable_id, uniqueness: { scope: [:votable_type, :voter_id], 
                                      message: "has already been up/down voted"}
  
  belongs_to :votable, polymorphic: true
  belongs_to :voter,
    class_name: "User",
    inverse_of: :up_down_votes
end
