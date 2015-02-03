require 'rails_helper'

RSpec.describe UserStory, type: :model do
  it {should validate_presence_of(:project_id)}

  before do
    @us = create_user_story
    @task_a = Task.new
    @task_b = Task.new
    @task_c = Task.new
  end

  describe "in general" do
    it "should default to being estimateable" do
      expect(@us.cannot_be_estimated?).to be_falsey
    end

    it "should be flaggable as cannot be estimated" do
      @us.cannot_be_estimated = 1
      @us.save!
      @us.reload
      expect(@us.cannot_be_estimated?).to be_truthy
    end

    describe "stakeholder field" do
      it "should default to blank" do
        expect(@us.stakeholder).to be_blank
      end

      it "should accept a string" do
        @us.stakeholder = "Mr Leroy Burns the Third of Edinbra"
        @us.save!
        expect(@us.stakeholder).to eq "Mr Leroy Burns the Third of Edinbra"
      end
    end
  end

  describe "#complete?" do
    it "should return false if no tasks" do
      @us.tasks = []
      @us.save!
      expect(@us.complete?).to be_falsey
      expect(@us.status).to eq "incomplete"
    end

    it "should return true if all tasks are complete" do
      @task_a.stub(:done?).and_return(true)
      @task_b.stub(:done?).and_return(true)
      @us.stub(:tasks).and_return([@task_a, @task_b])
      @us.complete?.should be_true
      @us.status.should == "complete"
    end

    it "should return false if any tasks are incomplete" do
      @task_a.stub(:done?).and_return(true)
      @task_b.stub(:done?).and_return(false)
      @us.stub(:tasks).and_return([@task_a, @task_b])
      @us.complete?.should be_false
      @us.status.should == "incomplete"
    end

    it "should return false if all tasks are incomplete" do
      @task_a.stub(:complete?).and_return(false)
      @task_b.stub(:complete?).and_return(false)
      @us.stub(:tasks).and_return([@task_a, @task_b])
      @us.complete?.should be_false
      @us.status.should == "incomplete"
    end
  end

  describe "#state?" do
    it "should return css class if user_story has no story point assigned" do
      @us.acceptance_criteria.stub(:blank?).and_return(false)
      @us.state.should == "estimate"
    end

    it "should return css class if user_story has story points assigned" do
      @us.story_points = 8
      @us.acceptance_criteria.stub(:blank?).and_return(false)
      @us.state.should == "plan"
    end

    it "should return css class if user_story cannot be estimated" do
      @us.cannot_be_estimated = 1
      @us.state.should == "clarify"
    end

    it "should return criteria state if user_story has no acceptance criteria and has not been estimated" do
      @us.acceptance_criteria.should be_blank
      @us.state.should == "criteria"
    end
  end

  describe "#inprogress?" do
    it "should return false if no tasks" do
      @us.inprogress?.should be_false
      @us.status.should == "incomplete"
    end

    it "should return true if any tasks are inprogress still" do
      @task_a.stub(:inprogress?).and_return(true)
      @task_b.stub(:inprogress?).and_return(false)
      @us.stub(:tasks).and_return([@task_a, @task_b])
      @us.inprogress?.should be_true
      @us.status.should == "inprogress"
    end

    it "should return false if all tasks are complete" do
      @task_a.stub(:inprogress?).and_return(false)
      @task_b.stub(:inprogress?).and_return(false)
      @us.stub(:tasks).and_return([@task_a, @task_b])
      @us.inprogress?.should be_false
      @us.status.should == "incomplete"
    end
  end

  describe "#copy!" do
    before(:each) do
      @us.project = Project.make!
      @us.definition = "definition"
      @us.save!
    end

    it "should create a new user story" do
      count = UserStory.count
      @us.copy!
      UserStory.count.should == count + 1
    end

    it "should copy acceptance criteria and tasks" do
      task1 = @us.tasks.make!(:done => false)
      task2 = @us.tasks.make!(:done => true)
      2.times { @us.acceptance_criteria.create(:detail => "It should work") }
      @us.reload
      @us.copy!
      us = UserStory.last
      us.should have(2).tasks
      us.should have(2).acceptance_criteria
    end
  end
end
