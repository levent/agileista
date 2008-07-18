require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  
  before(:each) do
    @it = self
    @us = UserStory.new
  end
  
  describe "#undefined?" do
    it "should return css class if user_story has no story point assigned" do
      @it.undefined?(@us).should == " class=\"undefined\""
    end
    
    it "should return css class if user_story has story points assigned" do
      @us.story_points = 8
      @it.undefined?(@us).should == " class=\"defined\""
    end
    
    it "should return css class if user_story cannot be estimated" do
      @us.cannot_be_estimated = 1
      @it.undefined?(@us).should == " class=\"toovague\""
    end
  end

  describe "#complete?" do
    it "should return class if user_story is complete" do
      @us.stub!(:complete?).and_return(true)
      @it.complete?(@us).should == " class=\"uscomplete\""
    end
  end
  
  describe "#claimed?" do
    it "should return class if user_story is inprogress?" do
      @us.stub!(:inprogress?).and_return(true)
      @it.claimed?(@us).should == " class=\"usclaimed\""      
    end
  end
  
  describe "#claimed_or_complete?" do
    it "should return uscomplete class if user_story is complete and not inprogress" do
      @us.stub!(:complete?).and_return(true)
      @us.stub!(:inprogress?).and_return(false)
      @it.claimed_or_complete?(@us).should == " class=\"uscomplete\""
    end
    
    it "should return uscomplete class if user_story is complete and inprogress" do
      #even though this is impossible?
      @us.stub!(:complete?).and_return(true)
      @us.stub!(:inprogress?).and_return(true)
      @it.claimed_or_complete?(@us).should == " class=\"uscomplete\""
    end
    
    it "should return usclaimed class if user_story is not complete and inprogress" do
      #even though this is impossible?
      @us.stub!(:complete?).and_return(false)
      @us.stub!(:inprogress?).and_return(true)
      @it.claimed_or_complete?(@us).should == " class=\"usclaimed\""
    end
  end
  
  describe "#unresolved_impediment_indicator" do
    it "should return * if there are any" do
      @account = Account.new
      @account.impediments.should_receive(:unresolved).and_return(['a'])
      @it.unresolved_impediment_indicator(@account).should == "<span class=\"yellow\">*</span>"
    end
    
    it "should return nothing if there aren't any unresolved impediments" do
      @account = Account.new
      @account.impediments.should_receive(:unresolved).and_return([])
      @it.unresolved_impediment_indicator(@account).should == nil
    end
  end

  describe "#show_stakeholder" do
    # deals with legacy before created_by
    it "should return by Unknown if no stakeholder or creator" do
      @it.show_stakeholder(@us).should == "Unknown"
    end
    
    it "should return by Creator if no stakeholder" do
      @us.person = Person.new(:name => 'monkey face')
      @it.show_stakeholder(@us).should == "monkey face"
    end
    
    it "should return by stakeholder if provided" do
      # @us.person = Person.new(:name => 'monkey face')
      @us.stakeholder = "fred dude"
      @it.show_stakeholder(@us).should == "fred dude"
    end

    it "should return by stakeholder if provided even if creator also there" do
      @us.person = Person.new(:name => 'monkey face')
      @us.stakeholder = "fred dude"
      @it.show_stakeholder(@us).should == "fred dude"
    end
  end
end