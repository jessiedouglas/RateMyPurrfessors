require 'spec_helper'

feature "college rating validations" do
  it "allows a basic rating" do
    rating = build(:college_rating)
    expect(rating).to be_valid
  end
  
  it "allows a rating with comments" do
    rating = build(:college_rating, comments: "hi mom")
    expect(rating).to be_valid
  end
  
  it "rejects a rating without a rater" do
    rating = build(:college_rating, rater: nil)
    expect(rating).to_not be_valid
  end
  
  it "rejects a rating without a college" do
    rating = build(:college_rating, college: nil)
    expect(rating).to_not be_valid
  end
  
  it "rejects a rating without selecting a required field" do
    categories = [
      :reputation,
      :location,
      :opportunities,
      :library,
      :grounds_and_common_areas,
      :internet,
      :food,
      :clubs,
      :social,
      :happiness
    ]
    
    categories.each_with_index do |category, i|
      user = create(:user, email: "#{i}@example.com")
      rating = build(:college_rating, rater: user, category => 0)
      expect(rating).to_not be_valid
    end
  end
  
  it "doesn't allow the same person to rate the same college more than once" do
    user = create(:user)
    college = create(:college)
    rating1 = create(:college_rating, college: college, rater: user)
    rating2 = build(:college_rating, college: college, rater: user)
    
    expect(rating2).to_not be_valid
  end
end

feature "college rating new/edit page" do
  shared_examples "rating form" do
    it "the page exists" do
      expect(page).to_not have_content "404"
    end
    
    it "has name and location of college" do
      college = College.last
      expect(page).to have_content college.name
      expect(page).to have_content college.location
    end
    
    it "has necessary fields" do
      expect(page).to have_content "Reputation"
      expect(page).to have_content "Location"
      expect(page).to have_content "Opportunities"
      expect(page).to have_content "Grounds and Common Areas"
      expect(page).to have_content "Library"
      expect(page).to have_content "Internet"
      expect(page).to have_content "Food"
      expect(page).to have_content "Social"
      expect(page).to have_content "Clubs"
      expect(page).to have_content "Happiness"
      expect(page).to have_content "Comments"
      expect(page).to have_content "Graduation Year"
    end
    
    it "has a submit button" do
      expect(page).to have_content "Submit"
    end
    
    it "redirects to college show page" do
      college = College.last
      
      choose("reputation_5")
      choose("location_5")
      choose("opportunities_5")
      choose("library_5")
      choose("grounds_and_common_areas_5")
      choose("internet_5")
      choose("food_5")
      choose("clubs_5")
      choose("social_5")
      choose("happiness_5")
      select("2000", from: "college_rating[graduation_year]")
      click_on("Submit")
      
      expect(page).to have_content college.name
      expect(page).to have_content "Rate This College"
    end
  end
  
  context "new rating" do
    before(:each) do
      sign_up_as_hello_world
      college = create(:college)
      visit new_college_college_rating_url(college)
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
      rating = create(:college_rating, comments: "hi mom", rater: user)
      visit edit_college_rating_url(rating)
    end
    
    it "has appropriate title" do
      expect(page).to have_content "Edit Rating"
    end
    
    it "is filled in as expected" do
      rating = CollegeRating.last
      
      expect(page).to have_content "hi mom"
    end
    
    it_behaves_like "rating form"
  end
  
  context "check authorizations" do
    it "doesn't allow a user to create/edit a rating if not signed in" do
      college = create(:college)
      visit new_college_college_rating_url(college)
      expect(page).to_not have_content "New Rating"
      
      rating = create(:college_rating)
      visit edit_college_rating_url(rating)
      expect(page).to_not have_content "Edit Rating"
    end
    
    it "doesn't allow a user to edit a rating they didn't create" do
      user = create(:user, email: "email@email.com")
      rating = create(:college_rating, rater: user)
      
      sign_up_as_hello_world
      visit edit_college_rating_url(rating)
      expect(page).to_not have_content "Edit Rating"
    end
  end
end