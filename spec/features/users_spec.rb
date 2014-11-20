require 'spec_helper'

feature "user show page" do
  before(:each) do
    sign_up_as_hello_world
    visit user_url(User.last)
  end
  
  it "has link to edit user info" do
    expect(page).to have_content "Edit my info"
  end
  
  it "edit info link redirects to user edit page" do
    click_on("Edit my info")
    expect(page).to have_content "Save"
  end
  
  context "user has no ratings" do
    it "doesn't show any ratings" do
      expect(page).to have_content "You have no ratings"
    end
    
    it "has links to rate professors and colleges" do
      expect(page).to have_content "Rate a Professor"
      expect(page).to have_content "Rate a College"
    end
  end
  
  context "user has college and professor ratings" do
    before(:each) do
      user = User.last
      professor = create(:professor, first_name: "Harold", last_name: "Kumar",)
      create(:professor_rating, professor: professor, rater: user)
      college = create(:college, name: "Phoenix University")
      create(:college_rating, college: college, rater: user)
      visit user_url(user)
      
      Capybara.match = :first
    end
    
    it "shows all ratings" do
      expect(page).to have_content "Harold Kumar"
      expect(page).to have_content "Phoenix University"
    end
    
    it "has links to edit and destroy ratings" do
      expect(page).to have_link "Edit"
      expect(page).to have_button "Delete"
    end
    
    it "edit link redirects to rating edit page" do
      find("section.ratings").click_link "Edit"
      expect(page).to have_content "Edit Rating"
    end
    
    it "destroy link destroys rating" do
      find("section.ratings").click_button "Delete"
      visit user_url(User.last)
      expect(page).to_not have_content "Harold Kumar"
    end
  end
end

feature "user edit page" do
  before(:each) do
    sign_up_as_hello_world
    visit user_url(User.last)
    click_on("Edit my info")
  end
  
  it "has link to save that redirects to user show page" do 
    expect(page).to have_button "Save"
    fill_in "user[password]", with: "Password"
    click_on "Save"
    expect(page).to have_content "Edit my info"
  end
  
  it "has appropriate fields" do
    expect(page).to have_field "Name"
    expect(page).to have_field "Email"
    expect(page).to have_content "College"
    expect(page).to have_field "Password"
  end
  
  it "doesn't allow a user to edit another user's info" do
    user = User.last
    click_on "Log Out"
    visit edit_user_url(user)
    expect(page).to_not have_content "Save"
    
    sign_up_as_demo
    visit edit_user_url(user)
    expect(page).to_not have_content "Save"
  end
end