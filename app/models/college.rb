class College < ActiveRecord::Base
  validates :name, :location, presence: true

  has_many :students,
    class_name: "User",
    inverse_of: :college

  has_many :professors, inverse_of: :college
end
