require 'spec_helper'

feature "professor validations" do
  it "accepts a professor with a first name, last name, college, and department" do
    professor = build(:professor)
    expect(professor).to be_valid
  end
  
  it "accepts a professor with a middle initial" do
    professor = build(:professor, middle_initial: "A")
    expect(professor).to be_valid
  end
  
  it "accepts a professor with a picture" do
    professor = build(:professor, filepicker_url: "hi.com")
    expect(professor).to be_valid
  end
  
  it "has a default picture url" do 
    professor = build(:professor)
    expect(professor.filepicker_url).to be
  end
  
  it "rejects a professor without a first name" do
    professor = build(:professor, first_name: "")
    expect(professor).to_not be_valid
  end
  
  it "rejects a professor without a last name" do
    professor = build(:professor, last_name: "")
    expect(professor).to_not be_valid
  end
  
  it "rejects a professor without a department" do
    professor = build(:professor, department: "")
    expect(professor).to_not be_valid
  end
  
  it "rejects a professor without a college" do
    professor = build(:professor, college: nil)
    expect(professor).to_not be_valid
  end
  
  it "doesn't allow two professors with the same name at the same college" do
    college = create(:college)
    professor1 = create(:professor, first_name: "Arnold", last_name: "Palmer", college: college)
    professor2 = build(:professor, first_name: "Arnold", last_name: "Palmer", college: college)
    expect(professor2).to_not be_valid
  end
end

feature "professor show page" do
  it "has a professor show page" do
    professor = create(:professor)
    visit professor_url(professor)
    expect(page).to_not have_content "404"
  end
  
  it "has the professor's name, college, and department" do
    professor = create(:professor)
    visit professor_url(professor)
    expect(page).to have_content professor.name
    expect(page).to have_content professor.college.name
    expect(page).to have_content professor.department
  end
  
  context "professor has no ratings" do
    it "doesn't show averages" do
      professor = create(:professor)
      visit professor_url(professor)
      expect(page).to_not have_content "Average Ratings"
    end
    
    it "doesn't show any ratings" do
      professor = create(:professor)
      visit professor_url(professor)
      expect(page).to have_content "There are no ratings for this professor"
    end
  end
  
  context "professor has ratings" do
    before(:each) do
      professor = create(:professor)
      user = create(:user, email: "hi@mom.com")
      create(:professor_rating, helpfulness: 3, professor: professor, comments: "lolol")
      create(:professor_rating, easiness: 1, professor: professor, rater: user, comments: "this is a rating")
    end
    
    it "shows correct averages" do
      professor = Professor.last
      rating1 = ProfessorRating.last
      rating2 = ProfessorRating.find(rating1.id - 1)
      visit professor_url(professor)
      
      expect(page).to have_content "#{(rating1.helpfulness + rating2.helpfulness * 1.0) / 2}"
      expect(page).to have_content "#{(rating1.easiness + rating2.easiness * 1.0) / 2}"
    end
    
    it "shows ratings" do
      professor = Professor.last
      visit professor_url(professor)
      expect(page).to have_content "lolol"
      expect(page).to have_content "this is a rating"
    end
  end
end

feature "new professor page" do
  it "has a new professor page" do
    sign_up_as_hello_world
    visit new_professor_url
    expect(page).to have_content "New Professor"
  end
  
  it "has inputs for first name, middle initial, last name, college, and department" do
    sign_up_as_hello_world
    visit new_professor_url
    expect(page).to have_content "First Name"
    expect(page).to have_content "Middle Initial"
    expect(page).to have_content "Last Name"
    expect(page).to have_content "College"
    expect(page).to have_content "Department"
  end
  
  it "has a submit button" do
    sign_up_as_hello_world
    visit new_professor_url
    expect(page).to have_content "Add Professor"
  end
  
  it "redirects to professor show page on creation" do
    college = create(:college)
    sign_up_as_hello_world
    visit new_professor_url
    
    fill_in "professor[first_name]", with: "Bob"
    fill_in "professor[last_name]", with: "Jones"
    select(college.name, from: "professor[college_id]")
    select("Meowthematics", from: "professor[department]")
    click_on("Add Professor")
    
    expect(page).to have_content "Bob Jones"
    expect(page).to have_content "Rate This Professor"
  end
  
  it "doesn't allow a user to create a professor if not logged in" do
    visit new_professor_url
    expect(page).to_not have_content "New Professor"
  end
end

feature "professor index page" do
  before(:each) do
    create(:professor, first_name: "Bob", last_name: "Jones")
    create(:professor, first_name: "Joe", last_name: "Smith")
    
    visit professors_url
  end
  
  it "exists" do
    expect(page).to have_content "All Professors"
  end
  
  it "has a search bar" do
    find("#match")
  end
  
  it "lists all professors" do
    expect(page).to have_content "Bob Jones"
    expect(page).to have_content "Joe Smith"
  end
  
  it "search redirects to same page" do
    fill_in "Professor Search", with: "Bob"
    click_on "Go!"
    expect(page).to have_content "Professors that match"
  end
  
  it "displays only searched-for professors" do
    fill_in "Professor Search", with: "Bob"
    click_on "Go!"
    
    expect(page).to have_content "Bob Jones"
    expect(page).to_not have_content "Joe Smith"
  end
end