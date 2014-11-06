json.extract! @user, :id, :college_id, :name, :email, :password_digest, :session_token

if @college
  json.college do
    json.name @college.name
    json.location @college.location
  end
end

json.all_ratings @all_ratings do |rating|
  if rating.class == ProfessorRating
    json.extract! rating, :id, :professor_id, :updated_at
    json.type "professor_rating"
    
    json.professor do
      json.id rating.professor.id
      json.department rating.professor.department
      json.college_id rating.professor.college_id
      json.name rating.professor.name
    
      json.college do 
        json.name rating.professor.college.name
      end
    end
  else
    json.extract! rating, :id, :college_id, :updated_at
    json.type "college_rating"
    
    json.college do
      json.id rating.college.id
      json.name rating.college.name
      json.location rating.college.location
    end
  end
end