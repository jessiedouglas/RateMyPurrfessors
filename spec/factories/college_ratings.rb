FactoryGirl.define do
  factory :college_rating do
    college
    association :rater, factory: :user
    reputation 5
    location 5
    opportunities 5
    library 5
    grounds_and_common_areas 5
    internet 5
    food 5
    clubs 5
    social 5
    happiness 5
    graduation_year 2012
  end
end