json.extract! @rating, :id, :rater_id, :course_code, :online_class, :helpfulness, :clarity, :easiness,
                    :taken_for_credit, :hotness, :comments, :attendance_is_mandatory, :interest,
                    :textbook_use, :grade_received, :created_at, :updated_at

json.professor do 
  json.extract! @rating.professor, :id, :last_name, :first_name, :middle_initial, :department, :college_id
  json.college do
    json.name @rating.professor.college.name
  end
end