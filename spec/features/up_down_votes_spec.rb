require 'spec_helper'

feature "up_down_vote validations" do
  it "rejects a vote without a votable type" do
    vote = build(:professor_rating_vote, votable_type: nil)
    expect(vote).to_not be_valid
  end
  
  shared_examples "college and professor ratings" do
    it "allows a basic vote" do
      vote = UpDownVote.last
      expect(vote).to be_valid
    end
    
    it "only allows vote values of 1 or -1" do
      vote = UpDownVote.last
      vote.vote_value = 1
      expect(vote).to be_valid
      
      vote.vote_value = -1
      expect(vote).to be_valid
      
      values = [0, rand(20) + 2, rand(20) * -1 - 2]
      values.each do |value|
        vote.vote_value = value
        expect(vote).to_not be_valid
      end
    end
    
    it "rejects a vote without a votable id" do
      vote = UpDownVote.last
      vote.votable_id = nil
      expect(vote).to_not be_valid
    end
    
    it "disallows a user to up or down vote the same rating twice" do
      user = create(:user, email: "email@email.com")
      rating = create(:professor_rating, rater: user)
      vote1 = create(:up_down_vote, votable_type: "ProfessorRating", votable_id: rating.id, voter: user)
      vote2 = build(:up_down_vote, votable_type: "ProfessorRating", votable_id: rating.id, voter: user)
      expect(vote2).to_not be_valid
    end
  end
  
  context "vote on a professor_rating" do
    before(:each) do
      create(:professor_rating_vote, votable_type: "ProfessorRating")
    end
    
    it_behaves_like "college and professor ratings"
  end
  
  context "vote on a college_rating" do
    before(:each) do
      create(:college_rating_vote, votable_type: "CollegeRating")
      
      it_behaves_like "college and professor ratings"
    end
  end
end