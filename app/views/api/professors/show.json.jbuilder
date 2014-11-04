json.extract! @professor, :id, :first_name, :middle_initial, :last_name, :department, :college_id

json.professor_ratings @professor.professor_ratings do |rating|
  json.extract! rating, :id, :rater_id, :course_code, :online_class, :helpfulness, :clarity, :easiness,
                    :taken_for_credit, :hotness, :comments, :attendance_is_mandatory, :interest,
                    :textbook_use, :grade_received, :created_at, :updated_at
                    
  json.up_down_votes rating.up_down_votes do |vote|
    json.extract! vote, :id, :vote_value, :voter_id
  end
end