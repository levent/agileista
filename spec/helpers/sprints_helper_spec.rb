require File.dirname(__FILE__) + '/../spec_helper'

describe SprintsHelper do
  include ApplicationHelper
  include SprintsHelper
  
  before(:each) do
    @it = self
    @sprint = Sprint.new
    sweeper = mock_model(SprintAuditSweeper)
    sweeper.stub!(:update)
    SprintElement.instance_variable_set(:@observer_peers, [sweeper])
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
  
  describe "#sprint_header" do
    before(:each) do
      
    end
    
    it "should display the sprint name and relevant info" do
      @sprint.start_at = 1.weeks.ago
      @sprint.end_at = 1.weeks.from_now
      @sprint.name = "Sprint A"
      @sprint.stub!(:hours_left).and_return(77)
      @it.should_receive(:show_date).with(@sprint.start_at).and_return('START')
      @it.should_receive(:show_date).with(@sprint.end_at).and_return('END')
      @it.sprint_header(@sprint).should == "Sprint A - <span class=\"small\">START to END (77 hours left - 0 story points planned)</span>"
    end
    
    it "should display number of allocated sp" do
      user_story = UserStory.make
      user_story.sprint = @sprint
      user_story.story_points = 18
      user_story.save!

      @sprint.account = Account.make
      @sprint.start_at = 1.weeks.ago
      @sprint.end_at = 1.weeks.from_now
      @sprint.name = "Sprint A"
      @sprint.stub!(:hours_left).and_return(77)
      @sprint.save!
      
      SprintElement.create!(:user_story => user_story, :sprint => @sprint)
      @it.should_receive(:show_date).with(@sprint.start_at).and_return('START')
      @it.should_receive(:show_date).with(@sprint.end_at).and_return('END')
      @it.sprint_header(@sprint).should == "Sprint A - <span class=\"small\">START to END (77 hours left - 18 story points planned)</span>"
    end
  end
end