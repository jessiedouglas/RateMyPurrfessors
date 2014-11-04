json.extract! @rating, :id, :rater_id, :reputation, :location, :opportunities, :library,
              :grounds_and_common_areas, :internet, :food, :clubs, :social, :happiness,
              :graduation_year, :comments, :created_at, :updated_at

json.college do 
  json.extract! @rating.college, :id, :name, :location
end