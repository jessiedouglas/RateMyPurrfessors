json.extract! @college, :id, :name, :location

json.professors @college.professors do |professor|
	json.id professor.id
	json.name professor.name
	json.department professor.department
end

json.college_ratings @college.college_ratings do |rating|
  json.extract! rating, :id, :rater_id, :reputation, :location, :opportunities, :library,
              :grounds_and_common_areas, :internet, :food, :clubs, :social, :happiness,
              :graduation_year, :comments, :created_at, :updated_at
  json.up_down_votes rating.up_down_votes do |vote|
    json.extract! vote, :id, :vote_value, :voter_id
  end
  
  json.vote_stats do 
    json.upvotes rating.upvotes
    json.downvotes rating.downvotes
  end
end

json.avg_college_ratings do
  json.avg_reputation @college.avg_reputation
  json.avg_location @college.avg_location
  json.avg_opportunities @college.avg_opportunities
  json.avg_library @college.avg_library
  json.avg_grounds_and_common_areas @college.avg_grounds_and_common_areas
  json.avg_internet @college.avg_internet
  json.avg_food @college.avg_food
  json.avg_clubs @college.avg_clubs
  json.avg_social @college.avg_social
  json.avg_happiness @college.avg_happiness
  json.avg_overall @college.avg_overall
end