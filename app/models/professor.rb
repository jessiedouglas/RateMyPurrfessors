class Professor < ActiveRecord::Base
  DEPARTMENTS = [
                "Agricatural Science",
                "Astrophysics",
                "Catfoodology",
                "Catonese",
                "Catstronomy",
                "Engineering",
                "Feline Studies",
                "Felosophy",
                "Fishics",
                "Fishology",
                "Fishtory",
                "Meowdern Art",
                "Meowndarin Chinese",
                "Meowsic",
                "Meowthmatics",
                "Pawlitical Science",
                "Predator Biology",
                "Prey Biology",
                "Psycatogy",
                "Sleeping",
                "Textiles (Yarn Studies)"
                ]

  validates :first_name, :last_name, :college_id, :department, presence: true
  validates :college_id, uniqueness: { scope: [
                                            :first_name,
                                            :last_name,
                                            :middle_initial
                                            ]}

  belongs_to :college, inverse_of: :professors
  
  has_many :professor_ratings, inverse_of: :professor, dependent: :destroy

  def name
    name = "#{self.first_name} "
    name += "#{self.middle_initial} " if self.middle_initial
    name += self.last_name

    name
  end
  
  def avg_helpfulness(all_ratings)
    return -1 if all_ratings.length === 0
    
    total = all_ratings.inject(0) do |accum, rating|
      accum + rating.helpfulness
    end
    
    (total * 10 / all_ratings.length).round / 10.0
  end
  
  def avg_clarity(all_ratings)
    return -1 if all_ratings.length === 0
    
    total = all_ratings.inject(0) do |accum, rating|
      accum + rating.clarity
    end
    
    (total * 10 / all_ratings.length).round / 10.0
  end
  
  def avg_easiness(all_ratings)
    return -1 if all_ratings.length === 0
    
    total = all_ratings.inject(0) do |accum, rating|
      accum + rating.easiness
    end
    
    (total * 10 / all_ratings.length).round / 10.0
  end
  
  def avg_hotness(all_ratings)
    return -1 if all_ratings.length === 0
    
    total = all_ratings.inject(0) do |accum, rating|
      accum + (rating.hotness ? 1 : 0)
    end
    
    total / all_ratings.length
  end
end
