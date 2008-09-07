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
  
  describe "#destroy" do
    describe "with user stories" do
      before(:each) do
        @it.name = "Alpha"
        @it.start_at = 1.months.ago
        @it.end_at = 1.months.from_now
        @it.account_id = 8
        @it.save!
        @us1 = @it.user_stories.new(:definition => 'As a wabbit I would like a carrot', :account_id => 8)
        @us2 = @it.user_stories.new(:definition => 'As a carrot I would like to avoid wabbits', :account_id => 8)
        @us1.save!
        @us2.save!
        se = SprintElement.new(:user_story => @us1, :sprint => @it)
        se.save!
        se = SprintElement.new(:user_story => @us2, :sprint => @it)
        se.save!
      end
      
      it "should remove sprint_id reference" do
        UserStory.find_all_by_sprint_id(@it.id).length.should == 2
        @it.destroy
        UserStory.find_all_by_sprint_id(@it.id).should be_blank
      end
      
      it "should remove sprint_elements" do
        SprintElement.count.should == 2
        @it.destroy
        SprintElement.count.should == 0
      end
    end
  end
end