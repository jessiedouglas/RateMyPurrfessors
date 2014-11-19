require 'spec_helper'

feature 'college validations' do
  it "accepts a college with a name and location" do
    college = create(:college)
    expect(college).to be_valid
  end
  
  it "rejects a college without a name" do
    college = build(:college, name: "")
    expect(college).to_not be_valid
  end
  
  it "rejects a college without a location" do
    college = build(:college, location: "")
    expect(college).to_not be_valid
  end
end

feature "college show page" do
  before(:each) do
    
  end
  
  it "has a show page for each college" do
    college = create(:college)
    visit college_url(college)
    expect(page).to_not have_content("404")
  end
  
  it "shows the college name and location" do
    college = create(:college)
    visit college_url(college)
    expect(page).to have_content college.name
    expect(page).to have_content college.location
  end
  
  it "doesn't show averages if college has no ratings" do
    college = create(:college)
    visit college_url(college)
    expect(page).to_not have_content "Average Ratings"
  end
  
  it "doesn't show ratings if college has no ratings" do
    college = create(:college)
    visit college_url(college)
    expect(page).to have_content "There are no ratings at this time"
  end
  
  it "shows professors at the college" do
    college = create(:college)
    professor = create(:professor, college: college)
    visit college_url(college)
    expect(page).to have_content professor.name
  end
  
  it "doesn't show other professors" do
    college = create(:college)
    college2 = create(:college, name: "Oberlin2")
    professor = create(:professor, college: college2)
    visit college_url(college)
    expect(page).to_not have_content professor.name
  end
  
  context "college has ratings" do
    before(:each) do
      college = create(:college)
      user = create(:user, email: "hi@mom.com")
      create(:college_rating, reputation: 3, college: college, comments: "hi mom")
      create(:college_rating, location: 1, college: college, comments: "abracadabra", rater: user)
    end
    
    it "shows correct averages" do
      visit college_url(College.last)
      rating2 = CollegeRating.last
      rating1 = CollegeRating.find(rating2.id - 1)
      expect(page).to have_content "Average Ratings"
      expect(page).to have_content "#{(rating1.reputation * 1.0 + rating2.reputation) / 2}"
      expect(page).to have_content "#{(rating1.location * 1.0 + rating2.location) / 2}"
    end
    
    it "shows ratings" do
      visit college_url(College.last)
      expect(page).to have_content "hi mom"
      expect(page).to have_content "abracadabra"
    end
  end
end

feature "professor index page" do
  it "exists"
  
  it "has a search bar"
  
  it "lists all colleges"
  
  it "search redirects to same page"
  
  it "displays only searched-for colleges"
end