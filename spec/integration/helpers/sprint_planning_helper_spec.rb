require 'spec_helper'

describe SprintPlanningHelper do
  include SprintPlanningHelper
  
  before(:each) do
    @it = self
    @sprint = Sprint.new
    @us = UserStory.new
  end

  describe "#sprint_assignment" do
    it "should return 'Unassigned' if sprint is blank?" do
      @sprint = nil
      @it.sprint_assignment(@sprint).should == 'Unassigned'
    end
    
    it "should be nil if sprint" do
      @it.sprint_assignment(@sprint).should be_nil
    end
  end
  
  describe "#tasked?" do
    it "should return class defined if tasked" do
      @us.should_receive(:tasks).and_return(['stuff', 'more stuff'])
      @it.tasked?(@us).should == " defined"
    end
    
    it "should return class undefined if not tasked" do
      @us.should_receive(:tasks).and_return([])
      @it.tasked?(@us).should == " undefined"
    end
  end
end
