FactoryGirl.define do
  factory :professor_rating do
    professor
    association :rater, factory: :user
    course_code "ECON203"
    helpfulness 5
    clarity 5
    easiness 5
    grade_received "A"
  end
end