json.array! @professors do |professor|
  json.extract! professor, :id, :first_name, :middle_initial, :last_name, :department, :college_id
  json.name professor.name
  
  json.college do
    json.name professor.college.name
  end
end