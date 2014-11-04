json.professors @professors do |professor|
  json.extract! professor, :id, :first_name, :middle_initial, :last_name, :department, :college_id
  
  json.college do
    json.name professor.college.name
  end
end