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
    
  def self.grad_years
    this_year = Date.today.year
    start_year = this_year - 25
    end_year = this_year + 5
    
    (start_year..end_year).to_a
  end
end
