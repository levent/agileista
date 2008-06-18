require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  
  before(:each) do
    @it = self
    @us = UserStory.new
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
end