require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  
  before(:each) do
    @it = self
  end

  describe "#complete?" do
    it "should return class if user_story is complete" do
      us = UserStory.new
      us.stub!(:complete?).and_return(true)
      @it.complete?(us).should == " class=\"uscomplete\""
    end
  end
  
  describe "#complete_or_claimed?" do
    
  end
end