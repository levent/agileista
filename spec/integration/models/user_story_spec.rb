require 'spec_helper'

describe UserStory do

  before(:each) do
    @project = Project.make!
    @us = UserStory.make!(:project => @project)
    @task_a = Task.new
    @task_b = Task.new
    @task_c = Task.new
  end

  describe "in general" do
    it "should default to being estimateable" do
      @us.stub!(:valid?).and_return(true)
      @us.save.should be_true
      @us.reload
      @us.cannot_be_estimated?.should be_false
    end

    it "should be flaggable as cannot be estimated" do
      @us.stub!(:valid?).and_return(true)
      @us.cannot_be_estimated = 1
      @us.save.should be_true
      @us.reload
      @us.cannot_be_estimated?.should be_true
    end

    describe "stakeholder field" do
      it "should default to blank" do
        @us.stakeholder.should be_blank
      end

      it "should accept a string" do
        @us.stub!(:valid?).and_return(true)
        @us.stakeholder = "Mr Leroy Burns the Third of Edinbra"
        @us.save
        @us.reload
        @us.stakeholder.should == "Mr Leroy Burns the Third of Edinbra"
      end
    end
  end

  describe "#complete?" do
    it "should return false if no tasks" do
      @us.stub!(:tasks).and_return([])
      @us.complete?.should be_false
    end

    it "should return true if all tasks are complete" do
      @task_a.stub!(:complete?).and_return(true)
      @task_b.stub!(:complete?).and_return(true)
      @us.stub!(:tasks).and_return([@task_a, @task_b])
      @us.complete?.should be_true
    end

    it "should return false if any tasks are incomplete" do
      @task_a.stub!(:complete?).and_return(true)
      @task_b.stub!(:complete?).and_return(false)
      @us.stub!(:tasks).and_return([@task_a, @task_b])
      @us.complete?.should be_false
    end

    it "should return false if all tasks are incomplete" do
      @task_a.stub!(:complete?).and_return(false)
      @task_b.stub!(:complete?).and_return(false)
      @us.stub!(:tasks).and_return([@task_a, @task_b])
      @us.complete?.should be_false
    end
  end

  describe "#state?" do
    it "should return css class if user_story has no story point assigned" do
      @us.acceptance_criteria.stub!(:blank?).and_return(false)
      @us.state.should == "estimate"
    end

    it "should return css class if user_story has story points assigned" do
      @us.story_points = 8
      @us.acceptance_criteria.stub!(:blank?).and_return(false)
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
    end

    it "should return true if any tasks are inprogress still" do
      @task_a.stub!(:inprogress?).and_return(true)
      @task_b.stub!(:inprogress?).and_return(false)
      @us.stub!(:tasks).and_return([@task_a, @task_b])
      @us.inprogress?.should be_true
    end

    it "should return false if all tasks are complete" do
      @task_a.stub!(:inprogress?).and_return(false)
      @task_b.stub!(:inprogress?).and_return(false)
      @us.stub!(:tasks).and_return([@task_a, @task_b])
      @us.inprogress?.should be_false
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
      task1 = @us.tasks.make!(:hours => 6)
      task2 = @us.tasks.make!(:hours => 0)
      2.times { @us.acceptance_criteria.create(:detail => "It should work") }
      @us.copy!
      us = UserStory.last
      us.should have(2).tasks
      us.should have(2).acceptance_criteria
    end
  end

  describe "self#complete_tasks" do
    it "should return an array of complete tasks" do
      @task_a.stub!(:complete?).and_return(true)
      @task_b.stub!(:complete?).and_return(true)
      @task_c.stub!(:complete?).and_return(false)
      @us.should_receive(:tasks).and_return([@task_a, @task_b, @task_c])
      UserStory.should_receive(:find).with(:all).and_return([@us])
      UserStory.complete_tasks.should == [@task_a, @task_b]
    end
  end

  describe "self#inprogress_tasks" do
    it "should return an array of inprogress tasks" do
      @task_a.stub!(:inprogress?).and_return(true)
      @task_b.stub!(:inprogress?).and_return(true)
      @task_c.stub!(:inprogress?).and_return(false)
      @us.should_receive(:tasks).and_return([@task_a, @task_b, @task_c])
      UserStory.should_receive(:find).with(:all).and_return([@us])
      UserStory.inprogress_tasks.should == [@task_a, @task_b]
    end
  end

  describe "self#incomplete_tasks" do
    it "should return an array of inprogress tasks" do
      @task_a.stub!(:incomplete?).and_return(true)
      @task_b.stub!(:incomplete?).and_return(true)
      @task_c.stub!(:incomplete?).and_return(false)
      @us.should_receive(:tasks).and_return([@task_a, @task_b, @task_c])
      UserStory.should_receive(:find).with(:all).and_return([@us])
      UserStory.incomplete_tasks.should == [@task_a, @task_b]
    end
  end

end
