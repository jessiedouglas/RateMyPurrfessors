FactoryGirl.define do
  factory :up_down_vote do
    association :voter, factory: :user
    vote_value 1
    
    factory :college_rating_vote do
      votable_type "CollegeRating"
      votable_id Faker::Number.number(3)
    end
    
    factory :professor_rating_vote do
      votable_type "ProfessorRating"
      votable_id Faker::Number.number(3)
    end
  end
end