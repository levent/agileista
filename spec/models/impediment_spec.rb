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
  
  describe "resolve" do
    it "should try and set the resolved_at time and save" do
      Time.freeze do
        @it.should_receive(:resolved_at=).with(Time.now)
        @it.should_receive(:save).and_return('tru')
        @it.resolve.should == 'tru'
      end
    end
  end
  
  describe "named_scope(s)" do
    describe "unresolved" do
      it "should correctly generate conditions for unresolved impediments" do
        Impediment.unresolved.proxy_options.should == {:conditions=>{:resolved_at=>nil}}
        Account.new.impediments.unresolved.proxy_options.should == {:conditions=>{:resolved_at=>nil}} # This test is a bit ugly and unneccessary?
      end
    end
  end
end
