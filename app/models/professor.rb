class Professor < ActiveRecord::Base
  validates :first_name, :last_name, :college_id, :department, presence: true
  validates :college_id, uniqueness: { scope: [
                                            :first_name,
                                            :last_name,
                                            :middle_initial
                                            ]}

  belongs_to :college, inverse_of: :professors
end
