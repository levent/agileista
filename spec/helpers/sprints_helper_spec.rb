require File.dirname(__FILE__) + '/../spec_helper'

describe SprintsHelper do
  include SprintsHelper
  
  before(:each) do
    @it = self
    @sprint = Sprint.new
    # @us = UserStory.new
  end

  describe "#identify_key_sprint" do
    it "should return current sprint class if so" do
      @sprint.should_receive(:current?).and_return(true)
      @it.identify_key_sprint(@sprint).should == "class=\"currentsprint\""
    end
    
    it "should return upcoming sprint class if so" do
      @sprint.should_receive(:current?).and_return(false)
      @sprint.should_receive(:upcoming?).and_return(true)
      @it.identify_key_sprint(@sprint).should == "class=\"upcomingsprint\""
    end
    
    it "should return empty string if old sprint" do
      @sprint.should_receive(:current?).and_return(false)
      @sprint.should_receive(:upcoming?).and_return(false)
      @it.identify_key_sprint(@sprint).should == ""
    end
  end
  # describe "#sprint_assignment" do
  #   it "should return 'Unassigned' if sprint is blank?" do
  #     @sprint = nil
  #     @it.sprint_assignment(@sprint).should == 'Unassigned'
  #   end
  #   
  #   it "should be nil if sprint" do
  #     @it.sprint_assignment(@sprint).should be_nil
  #   end
  # end
  # 
  # describe "#tasked?" do
  #   it "should return class defined if tasked" do
  #     @us.should_receive(:tasks).and_return(['stuff', 'more stuff'])
  #     @it.tasked?(@us).should == " defined"
  #   end
  #   
  #   it "should return class undefined if not tasked" do
  #     @us.should_receive(:tasks).and_return([])
  #     @it.tasked?(@us).should == " undefined"
  #   end
  # end
end