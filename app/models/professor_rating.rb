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
end
