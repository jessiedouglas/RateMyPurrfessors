# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all

User.create!({ name: "demo", email: "demo@demo.com", password: "demodemo" })

users = []

20.times do 
  u = User.create!({
                    name: Faker::Name.name,
                    email: Faker::Internet.email,
                    password: "password"
                  })
  users << u
end


College.destroy_all

colleges = [
      College.create!({ name: "Bryn Meow Pawledge", location: "Lower Merion Twp, PA" }),
      College.create!({ name: "Cat Georgia Tech", location: "Atlanta, GA" }),
      College.create!({ name: "Catella Unipurrsity", location: "Online" }),
      College.create!({ name: "Catmont McKitty Pawledge", location: "Claremone, CA" }),
      College.create!({ name: "Catsachusetts Institute of Catnology", location: "Cambridge, MA" }),
      College.create!({ name: "Catvard Unipurrsity", location: "Cambridge, MA" }),
      College.create!({ name: "Dartmeowth Pawledge", location: "Hanover, NH" }),
      College.create!({ name: "Furball State Unipurrsity", location: "Muncie, IN" }),
      College.create!({ name: "Mice Unipurrsity", location: "Houston, TX" }),
      College.create!({ name: "Opurrlin Pawledge", location: "Oberlin, OH" }),
      College.create!({ name: "Pawprintston Unipurrsity", location: "Princeton, NJ" }),
      College.create!({ name: "SUNY Purrchase", location: "Purchase, NY" }),
      College.create!({ name: "Swatmore Pawledge", location: "Swarthmore, PA" }),
      College.create!({ name: "Unipurrsity of Cincicati", location: "Cincinnati, OH" }),
      College.create!({ name: "Unipurrsity of Mane", location: "Orono, ME" }),
      College.create!({ name: "Unipurrsity of Pittspurrgh", location: "Pittsburgh, PA" }),
      College.create!({ name: "Unipurrsity of Whiskerson-Catison", location: "Madison, WI" }),
      College.create!({ name: "Washington and Cat Unipurrsity", location: "Lexington, VA" }),
      College.create!({ name: "West Furginia Unipurrsity", location: "Morgantown, WV" }),
      College.create!({ name: "Yowl Unipurrsity", location: "New Haven, CT" }),
      ]


Professor.destroy_all
CollegeRating.destroy_all

departments = Professor::DEPARTMENTS

Professor.create!({
                  first_name: "Abbott", 
                  middle_initial: "M", 
                  last_name: "Whiskers", 
                  college_id: colleges[rand(colleges.length)].id,
                  department: departments[rand(departments.length)]
                  })

professors = []

colleges.each do |college|
  10.times do |i|
    p = Professor.create!({
                            first_name: Faker::Name.first_name,
                            last_name: "Cat",
                            college_id: college.id,
                            department: departments[rand(departments.length)]
                          })
    professors << p
  end
  
  20.times do |i|
    CollegeRating.create!({
                            college_id: college.id,
                            rater_id: users[i].id,
                            reputation: rand(5) + 1,
                            location: rand(5) + 1,
                            opportunities: rand(5) + 1,
                            library: rand(5) + 1,
                            grounds_and_common_areas: rand(5) + 1,
                            internet: rand(5) + 1,
                            food: rand(5) + 1,
                            clubs: rand(5) + 1,
                            social: rand(5) + 1,
                            happiness: rand(5) + 1,
                            graduation_year: rand(20) + 1989,
                            comments: Faker::Lorem.paragraph
                          })
  end
end

ProfessorRating.destroy_all

grades = ProfessorRating::GRADES

professors.each do |professor|
  20.times do |i|
    ProfessorRating.create!({
                              professor_id: professor.id,
                              rater_id: users[i].id,
                              course_code: (Faker::App.name).split(" ").first + (Faker::Number.number(3)).to_s,
                              online_class: (rand(5) > 3 ? true : false),
                              helpfulness: rand(5) + 1,
                              clarity: rand(5) + 1,
                              easiness: rand(5) + 1,
                              taken_for_credit: (rand(5) > 3 ? true : false),
                              hotness: (rand(2) == 0 ? true : false),
                              comments: Faker::Lorem.paragraph,
                              attendance_is_mandatory: (rand(2) == 0 ? true : false),
                              interest: rand(5) + 1,
                              textbook_use: rand(5) + 1,
                              grade_received: grades[rand(grades.length)]
                            })
  end
end

