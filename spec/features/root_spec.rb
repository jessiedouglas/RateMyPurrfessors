require 'spec_helper'

feature "home page" do
  it "has links to professor and college index pages" do
    visit root_url
    expect(page).to have_content "find/rate a professor"
    expect(page).to have_content "find/rate a college"
  end
end

feature "header" do
  it "contains the site logo" do
    visit root_url
    find("div.logo > a > img")
  end
  
  it "has a link to the home page" do
    visit new_session_url
    find("div.logo > a").click
    expect(page).to have_content "Find the thing the professor the college you're looking for"
  end
  
  it "has a search bar" do
    visit root_url
    expect(page).to have_content "GO!"
  end
  
  it "has a link to the sign in page when the user is logged out" do
    visit root_url
    expect(page).to have_content "Log In/Sign Up"
  end
  
  it "appears on every page" do
    sign_up_as_hello_world
    college = create(:college)
    professor = create(:professor)
    college_rating = create(:college_rating, rater: User.last)
    professor_rating = create(:professor_rating, rater: User.last)
    
    urls = [
      root_url,
      new_session_url,
      new_user_url,
      search_url,
      professors_url,
      new_professor_url,
      user_url(User.last),
      professor_url(professor),
      college_url(college),
      edit_college_rating_url(college_rating),
      edit_professor_rating_url(professor_rating),
      colleges_url
    ]
    
    urls.each do |url|
      visit url
      expect(page).to have_content "GO!"
    end
  end
end

feature "footer" do
  it "has a link to the home page" do
    visit new_session_url
    expect(page).to have_content "www.ratemypurrfessors.com"
    
    click_on "www.ratemypurrfessors.com"
    expect(page).to have_content "Find the thing the professor the college you're looking for"
  end

  it "appears on every page" do
    sign_up_as_hello_world
    college = create(:college)
    professor = create(:professor)
    college_rating = create(:college_rating, rater: User.last)
    professor_rating = create(:professor_rating, rater: User.last)
    
    urls = [
      root_url,
      new_session_url,
      new_user_url,
      search_url,
      professors_url,
      new_professor_url,
      user_url(User.last),
      professor_url(professor),
      college_url(college),
      edit_college_rating_url(college_rating),
      edit_professor_rating_url(professor_rating),
      colleges_url
    ]
    
    urls.each do |url|
      visit url
      expect(page).to have_content "www.ratemypurrfessors.com"
    end
  end
end

feature "general search page" do
  it "has another search bar" do
    visit search_url
    find("input#match")
  end
  
  it "only shows searched-for elements" do
    create(:professor, first_name: "Bob", last_name: "Jones")
    create(:professor, first_name: "Joe", last_name: "Smith")
    
    visit search_url
    fill_in "Search", with: "Bob"
    click_on "Go!"
    
    expect(page).to have_content "Bob Jones"
    expect(page).to_not have_content "Joe Smith"
  end
end