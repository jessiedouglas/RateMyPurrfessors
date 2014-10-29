class ProfessorRating < ActiveRecord::Base
  validates :professor_id, :rater_id, :course_code, :helpfulness, presence: true
  validates :clarity, :easiness, :grade_received, presence: true
  validates :professor_id, uniqueness: { scope: :rater_id }
  validates :course_code, :online_class, :taken_for_credit, :hotness, inclusion: { true, false }
  validates :attendance_is_mandatory, inclusion: { true, false }
  
  belongs_to :professor, inverse_of: :professor_ratings
  
  belongs_to :rater,
    class_name: "User",
    foreign_key: :rater_id,
    inverse_of: :professor_ratings
end
