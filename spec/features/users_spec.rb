require 'spec_helper'

feature "user show page" do
  it "has link to edit user info"
  
  it "edit info link redirects to user edit page"
  
  context "user has no ratings" do
    it "doesn't show any ratings"
  end
  
  context "user has college and professor ratings" do
    it "shows all ratings"
    
    it "has links to edit and destroy ratings"
    
    it "edit link redirects to rating edit page"
    
    it "destroy link destroys rating"
  end
end

feature "user edit page" do
  it "has link to save"
  
  it "has appropriate fields"
  
  it "doesn't allow a user to edit another user's info"
end