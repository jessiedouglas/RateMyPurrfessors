json.extract! @professor, :id, :first_name, :middle_initial, :last_name, :department, :college_id, :filepicker_url
json.name @professor.name

json.college do 
  json.name @professor.college.name
end

json.professor_ratings @professor.professor_ratings do |rating|
  json.extract! rating, :id, :rater_id, :course_code, :online_class, :helpfulness, :clarity, :easiness,
                    :taken_for_credit, :hotness, :comments, :attendance_is_mandatory, :interest,
                    :textbook_use, :grade_received, :created_at, :updated_at
                    
  json.vote_stats do
    json.upvotes rating.upvotes
    json.downvotes rating.downvotes
    if logged_in?
      json.has_already_voted_on rating.already_voted_on?(current_user)
    else
      json.has_already_voted_on false
    end
  end
end

json.avg_professor_ratings do
  json.avg_helpfulness @professor.avg_helpfulness
  json.avg_clarity @professor.avg_clarity
  json.avg_easiness @professor.avg_easiness
  json.avg_hotness @professor.avg_hotness
end