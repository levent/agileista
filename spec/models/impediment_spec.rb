require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Impediment do
  before(:each) do
    @it = Impediment.new
  end

  describe "in general" do
    it "should be invalid without a description" do
      @it.should require_a(:description)
    end
    
    it "should be invalid without a person_id" do
      @it.should require_a(:person_id)
    end
    
    it "should be invalid without an account_id" do
      @it.should require_a(:account_id)
    end
    
    it "should belong to a team_member" do
      @it.should belong_to(:team_member)
    end
    
    it "should belong to an account" do
      @it.should belong_to(:account)
    end
  end
end
