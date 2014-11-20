require 'spec_helper'

feature "professor rating validations" do
  it "allows a basic professor rating" do
    rating = build(:professor_rating)
    expect(rating).to be_valid
  end
  
  it "allows a rating with online class checked" do
    rating = build(:professor_rating, online_class: true)
    expect(rating).to be_valid
  end
  
  it "allows a rating not taken for credit" do
    rating = build(:professor_rating, taken_for_credit: false)
    expect(rating).to be_valid
  end
  
  it "allows a rating with hotness checked" do
    rating = build(:professor_rating, hotness: true)
    expect(rating).to be_valid
  end
  
  it "allows a rating with comments" do
    rating = build(:professor_rating, comments: "hi mom")
    expect(rating).to be_valid
  end
  
  it "allows a rating with attendance checked" do
    rating = build(:professor_rating, attendance_is_mandatory: true)
    expect(rating).to be_valid
  end
  
  it "allows a rating with interest selected" do
    rating = build(:professor_rating, interest: 5)
    expect(rating).to be_valid
  end
  
  it "allows a rating with textbook use selected" do
    rating = build(:professor_rating, textbook_use: 5)
    expect(rating).to be_valid
  end
  
  it "rejects a rating without a professor" do
    rating = build(:professor_rating, professor: nil)
    expect(rating).to_not be_valid
  end
  
  it "rejects a rating without a user" do
    rating = build(:professor_rating, rater: nil)
    expect(rating).to_not be_valid
  end
  
  it "rejects a rating without a course code" do
    rating = build(:professor_rating, course_code: "")
    expect(rating).to_not be_valid
  end
  
  it "rejects a rating without a helpfulness rating" do
    rating = build(:professor_rating, helpfulness: 0)
    expect(rating).to_not be_valid
  end
  
  it "rejects a rating without a clarity rating" do 
    rating = build(:professor_rating, clarity: 0)
    expect(rating).to_not be_valid
  end
  
  it "rejects a rating without an easiness rating" do  
    rating = build(:professor_rating, easiness: 0)
    expect(rating).to_not be_valid
  end
  
  it "rejects a rating without a grade received" do
    rating = build(:professor_rating, grade_received: nil)
    expect(rating).to_not be_valid
  end
  
  it "disallows a user to rate the same professor multiple times" do
    user = create(:user)
    professor = create(:professor)
    rating1 = create(:professor_rating, rater: user, professor: professor)
    rating2 = build(:professor_rating, rater: user, professor: professor)
    
    expect(rating2).to_not be_valid
  end
end

feature "college rating new/edit page" do
  shared_examples "rating form" do
    it "the page exists" do
      expect(page).to_not have_content "404"
    end
    
    it "has name, college, and department of professor" do
      professor = Professor.last
      expect(page).to have_content professor.name
      expect(page).to have_content professor.college.name
      expect(page).to have_content professor.department
    end
    
    it "has necessary fields" do
      expect(page).to have_field "Course Code"
      expect(page).to have_content "This class was online"
      expect(page).to have_content "Helpfulness"
      expect(page).to have_content "Clarity"
      expect(page).to have_content "Easiness"
      expect(page).to have_content "I did not take this course for credit"
      expect(page).to have_content "ME-OW"
      expect(page).to have_field "Comments"
      expect(page).to have_content "Attendance was STRICTLY ENFORCED"
      expect(page).to have_content "Interest"
      expect(page).to have_content "Textbook Use"
      expect(page).to have_content "Grade Received"
    end
    
    it "has a submit button" do
      expect(page).to have_content "Submit"
    end
    
    it "redirects to professor show page" do
      professor = Professor.last
      
      fill_in "Course Code", with: "ECON101"
      choose("helpfulness_5")
      choose("clarity_5")
      choose("easiness_5")
      select("A", from: "professor_rating[grade_received]")
      click_on("Submit")
      
      expect(page).to have_content professor.name
      expect(page).to have_content "Rate This Professor"
    end
  end
  
  context "new rating" do
    before(:each) do
      sign_up_as_hello_world
      professor = create(:professor)
      visit new_professor_professor_rating_url(professor)
    end
    
    it "has appropriate title" do
      expect(page).to have_content "New Rating"
    end
    
    it_behaves_like "rating form"
  end
  
  context "edit rating" do
    before(:each) do
      sign_up_as_hello_world
      user = User.find_by_email("hello@world.com")
      rating = create(:professor_rating, comments: "hi mom", rater: user)
      visit edit_professor_rating_url(rating)
    end
    
    it "has appropriate title" do
      expect(page).to have_content "Edit Rating"
    end
    
    it "is filled in as expected" do
      expect(page).to have_content "hi mom"
    end
    
    it_behaves_like "rating form"
  end
  
  context "check authorizations" do
    it "doesn't allow a user to create/edit a rating if not signed in" do
      professor = create(:professor)
      visit new_professor_professor_rating_url(professor)
      expect(page).to_not have_content "New Rating"
      
      rating = create(:professor_rating)
      visit edit_professor_rating_url(rating)
      expect(page).to_not have_content "Edit Rating"
    end
    
    it "doesn't allow a user to edit a rating they didn't create" do
      user = create(:user, email: "email@email.com")
      rating = create(:professor_rating, rater: user)
      
      sign_up_as_hello_world
      visit edit_professor_rating_url(rating)
      expect(page).to_not have_content "Edit Rating"
    end
  end
end