json.array! @matches do |match|
  if match.class == Professor
    json.extract! match, :id, :department, :college_id
    json.name match.name
    json.type "professor"
    
    json.college do 
      json.name match.college.name
    end
  else
    json.extract! match, :id, :name, :location
    json.type "college"
  end
end