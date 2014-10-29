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
  
  has_many :professor_ratings, inverse_of: :professor

  def name
    name = "#{self.first_name} "
    name += "#{self.middle_initial} " if self.middle_initial
    name += self.last_name

    name
  end
end
