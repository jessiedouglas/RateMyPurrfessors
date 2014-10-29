class College < ActiveRecord::Base
  RATING_PROPS = [
                  "reputation", 
                  "location", 
                  "opportunities", 
                  "library", 
                  "grounds_and_common_areas", 
                  "internet", 
                  "food", 
                  "clubs", 
                  "social", 
                  "happiness"
                ]
  
  validates :name, :location, presence: true

  has_many :students,
    class_name: "User",
    inverse_of: :college

  has_many :professors, inverse_of: :college
  
  has_many :college_ratings, inverse_of: :college
  
  RATING_PROPS.each do |prop|
    define_method("avg_#{prop}") do |all_ratings|
      total = all_ratings.inject(0) do |accum, rating|
        accum + rating.send(prop)
      end
      
      (total * 10 / all_ratings.length).round / 10.0
    end
  end
  
  def avg_overall(all_ratings)
    total = RATING_PROPS.inject(0) do |accum, prop|
      accum + self.send("avg_#{prop}", all_ratings)
    end
    
    (total).round / 10.0
  end
end
