require 'spec_helper'

describe Sprint do

  before do
    @it = Sprint.new
  end

  it { should have_many(:sprint_elements).dependent(:delete_all) }
  it { should have_many(:user_stories) }
  it { should have_many(:burndowns) }

  it { should belong_to :project }
  it { should validate_presence_of :project_id }
  it { should validate_presence_of :start_at }
  it { should validate_presence_of :end_at }
  it { should validate_presence_of :name }

  context "auto setting end time" do
    it "should set it on save based on project's iteration length" do
      start = 1.day.from_now
      project = Project.make!(:iteration_length => 1)
      sprint = Sprint.create!(:name => "Disco dance prep", :project => project, :start_at => start)
      project.iteration_length.weeks.from_now(1.day.ago(start)).end_of_day.should == sprint.end_at
    end

    it "should set it to end of day on subsequent saves" do
      start = 19.days.from_now
      project = Project.make!(:iteration_length => 1)
      sprint = Sprint.create!(:name => "Disco dance prep", :project => project, :start_at => start)
      finish = project.iteration_length.weeks.from_now(1.day.ago(start))
      initial_finish = sprint.end_at
      sprint.end_at = finish
      sprint.save!
      sprint.reload
      sprint.end_at.should.to_s == initial_finish.to_s
    end
  end
  
  describe "#velocity" do
    before(:each) do
      us1 = UserStory.new(:story_points => 3)
      us2 = UserStory.new(:story_points => 12)
      us3 = UserStory.new(:story_points => 5)
      us4 = UserStory.new(:story_points => 8)
      us5 = UserStory.new(:story_points => 13)
      us6 = UserStory.new(:story_points => nil)
      us7 = UserStory.new(:story_points => 20)
      us8 = UserStory.new(:story_points => 40)
      
      us1.stub!(:complete?).and_return(true)
      us2.stub!(:complete?).and_return(true)
      us3.stub!(:complete?).and_return(false)
      us4.stub!(:complete?).and_return(true)
      us5.stub!(:complete?).and_return(true)
      us6.stub!(:complete?).and_return(false)
      us7.stub!(:complete?).and_return(true)
      us8.stub!(:complete?).and_return(false)
      
      @sprint = Sprint.new(:name => "sprint a")
      @sprint.stub!(:user_stories).and_return([us1, us2, us3, us4, us5, us6, us7, us8])
      @sprint.start_at = 3.months.ago
      @sprint.end_at = 2.months.ago
      @sprint.stub!(:project_id).and_return(19)
    end
    
    it "should return the total story points for all the complete user stories" do
      @sprint.calculated_velocity.should == 56
      @sprint.velocity.should == 56
    end
  end

  describe "#validate" do
    it "should require start and end to be in right order" do
      @it.start_at = 1.day.from_now
      @it.end_at = 1.day.ago
      @it.validate
      @it.errors[:start_at].should include("and end at must be different")
    end
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
        @project = Project.make!
        @sprint = Sprint.make!(:project => @project)
        @user_story = UserStory.make!(:project => @project, :sprint => @sprint)
        @sprint_element = SprintElement.make!(:sprint => @sprint, :user_story => @user_story)
      end

      it "should remove sprint_id reference" do
        UserStory.find_all_by_sprint_id(@sprint.id).should_not be_blank
        @sprint_element.sprint.destroy
        UserStory.find_all_by_sprint_id(@sprint.id).should be_blank
      end

      it "should remove sprint_elements" do
        @sprint_element.sprint.destroy
        SprintElement.count.should == 0
      end
    end
  end
end
