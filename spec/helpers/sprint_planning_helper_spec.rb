require File.dirname(__FILE__) + '/../spec_helper'

describe SprintPlanningHelper do
  include SprintPlanningHelper
  
  before(:each) do
    @it = self
    @sprint = Sprint.new
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
end