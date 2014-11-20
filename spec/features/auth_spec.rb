require 'spec_helper'

feature "the sign up process" do
  
  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up"
  end
  
  it "shows username on the homepage after signup" do 
    visit new_user_url
    sign_up_as_hello_world
    visit root_url
    expect(page).to have_content "hello_world"
  end
  
  it "takes user to user show page after signup" do 
    visit new_user_url
    sign_up_as_hello_world
    expect(page).to have_content "Edit my info"
  end
  
  it "allows a basic sign up" do
    user = FactoryGirl.create(:user)
    expect(user).to be_valid
  end
  
  it "requires name" do
    user = build(:user, name: "")
    expect(user).not_to be_valid
  end
  
  context "password" do
    it "requires a password" do 
      user = build(:user, password: "")
      expect(user).to_not be_valid
    end
    
    it "requires a password of at least 6 characters" do 
      user = build(:user, password: "hi")
      expect(user).to_not be_valid
    end
  end
  
  context "email" do
    it "requires an email" do 
      user = build(:user, email: "")
      expect(user).to_not be_valid
    end
    
    it "requires an email in standard format" do 
      users = [build(:user, email: "hi"),
              build(:user, email: "hi@"),
              build(:user, email: "hi@."),
              build(:user, email: "hi@.com"),
              build(:user, email: "@"),
              build(:user, email: "."),
              build(:user, email: "hi.com"),
              build(:user, email: "@hi.com")
            ]
      users.each do |user|
        expect(user).to_not be_valid
      end
    end
    
    it "doesn't allow two users with the same email" do
      user1 = create(:user)
      user2 = build(:user, name: "User2", password: "heythere")
      expect(user2).to_not be_valid
    end
  end
  
  it "allows college" do
    college = create(:college)
    user = create(:user, college_id: college.id)
    expect(user).to be_valid
  end
  
  it "doesn't allow user to visit sign up page after sign up" do
    visit new_user_url
    sign_up_as_hello_world
    visit new_user_url
    expect(page).to have_content "Edit my info"
  end
end

feature "the sign in process" do
  it "has a new session page" do
    visit new_session_url
    expect(page).to have_content "Log In"
  end

  it "shows username on the homepage after log in" do
    sign_up_as_hello_world
    click_on("Log Out")
    login_as_hello_world
    visit root_url
    expect(page).to have_content "hello_world"
  end
  
  it "takes user to user show page after log in" do
    sign_up_as_hello_world
    click_on("Log Out")
    login_as_hello_world
    expect(page).to have_content "Edit my info"
  end
  
  it "requires email" do
    visit new_session_url
    fill_in "user[password]", with: "Password"
    click_on("Log In")
    expect(page).to_not have_content "Edit my info"
  end
  
  it "requires password" do
    visit new_session_url
    fill_in "user[email]", with: "hi@hi.com"
    click_on("Log In")
    expect(page).to_not have_content "Edit my info"
  end
  
  it "requires correct email/password combination" do
    sign_up_as_hello_world
    click_on("Log Out")
    
    login_as("email@email.com", "Password")
    expect(page).to have_content "Incorrect email/password combination"
    
    login_as("hello@world.com", "llama")
    expect(page).to have_content "Incorrect email/password combination"
  end
  
  context "demo user" do
    it "allows user to sign in with a demo account" do
      sign_up_as_demo
      click_on("Log Out")
      login_as_demo
      expect(page).to have_content "Edit my info"
    end
  end
  
  it "doesn't allow user to visit the log in page after log in" do
    sign_up_as_hello_world
    click_on("Log Out")
    login_as_hello_world
    visit new_session_url
    expect(page).to have_content "Edit my info"
  end
end

feature "logging out" do 
  it "begins with a logged out state" do
    visit root_url
    expect(page).to have_content "Log In/Sign Up"
  end
  
  it "doesn't show username on the homepage after log out" do
    sign_up_as_hello_world
    click_on("Log Out")
    expect(page).to_not have_content "hello_world"
  end
  
  it "doesn't allow user to see user show page after log out" do
    user = create(:user)
    visit user_url(user.id)
    expect(page).to_not have_content "Edit my info"
  end
end