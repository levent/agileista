require File.dirname(__FILE__) + '/../spec_helper'

describe Sprint do
  
  before(:each) do
    @it = Sprint.new
    # @task_a = Task.new
    # @task_b = Task.new
  end

  describe "#upcoming?" do
    it "should return true if starts in the future" do
      @it.start_at = 1.weeks.from_now
      @it.end_at = 2.weeks.from_now
      @it.upcoming?.should be_true
    end
    
    it "should return false if already started" do
      @it.start_at = 1.weeks.ago
      @it.end_at = 2.weeks.from_now
      @it.upcoming?.should be_false
    end
    
    it "should return false if already complete" do
      @it.start_at = 2.weeks.ago
      @it.end_at = 1.weeks.ago
      @it.upcoming?.should be_false
    end
  end
  
  describe "#current?" do
    it "should return true if active sprint" do
      @it.start_at = 1.weeks.ago
      @it.end_at = 2.weeks.from_now
      @it.current?.should be_true
    end

    it "should return false if complete" do
      @it.start_at = 2.weeks.ago
      @it.end_at = 1.weeks.ago
      @it.current?.should be_false
    end
    
    it "should return false if upcoming" do
      @it.start_at = 1.weeks.from_now
      @it.end_at = 2.weeks.from_now
      @it.current?.should be_false
    end
  end
end