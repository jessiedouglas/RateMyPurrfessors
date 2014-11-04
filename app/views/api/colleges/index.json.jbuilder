json.colleges @colleges do |college|
  json.extract! college, :id, :name, :location
end