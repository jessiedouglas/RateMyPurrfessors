FactoryGirl.define do
  factory :user do
    name "Jane Doe"
    email Faker::Internet.email
    password "password"
    
    factory :facebook_user do
      uid Faker::Number.number(10)
    end
  end
end