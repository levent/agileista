require 'rails_helper'

RSpec.describe UserStory, type: :model do
  it {should validate_presence_of(:project_id)}

  before do
    @us = create_user_story
    @task_a = create_task
    @task_b = create_task
    @task_c = create_task
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
      @task_a.done = true
      @task_b.done = true
      @us.tasks = [@task_a, @task_b]
      expect(@us.complete?).to be_truthy
      expect(@us.status).to eq "complete"
    end

    it "should return false if any tasks are incomplete" do
      @task_a.done = true
      @task_b.done = false
      @us.tasks = [@task_a, @task_b]
      expect(@us.complete?).to be_falsey
      expect(@us.status).to eq "incomplete"
    end

    it "should return false if all tasks are incomplete" do
      @task_a.done = false
      @task_b.done = false
      @us.tasks = [@task_a, @task_b]
      expect(@us.complete?).to be_falsey
      expect(@us.status).to eq "incomplete"
    end
  end

  describe "#state?" do
    it "should return css class if user_story has no story point assigned" do
      create_acceptance_criterion(@us)
      @us.reload
      expect(@us.state).to eq "estimate"
    end

    it "should return css class if user_story has story points assigned" do
      create_acceptance_criterion(@us)
      @us.story_points = 8
      @us.save!
      @us.reload
      expect(@us.state).to eq "plan"
    end

    it "should return css class if user_story cannot be estimated" do
      @us.cannot_be_estimated = 1
      expect(@us.state).to eq "clarify"
    end

    it "should return criteria state if user_story has no acceptance criteria and has not been estimated" do
      expect(@us.state).to eq "criteria"
    end
  end

  describe "#inprogress?" do
    it "should return false if no tasks" do
      expect(@us.inprogress?).to be_falsey
      expect(@us.status).to eq "incomplete"
    end

    it "should return true if any tasks are inprogress still" do
      allow(@task_a).to receive(:inprogress?) { true }
      allow(@task_b).to receive(:inprogress?) { false }
      @us.tasks = [@task_a, @task_b]
      expect(@us.inprogress?).to be_truthy
      expect(@us.status).to eq "inprogress"
    end

    it "should return false if all tasks are complete" do
      allow(@task_a).to receive(:inprogress?) { false }
      allow(@task_b).to receive(:inprogress?) { false }
      @us.tasks = [@task_a, @task_b]
      expect(@us.inprogress?).to be_falsey
      expect(@us.status).to eq "incomplete"
    end
  end

  describe "#copy!" do
    before do
      @us.project = create_project
      @us.definition = "definition"
      @us.save!
    end

    it "should create a new user story" do
      count = UserStory.count
      @us.copy!
      expect(UserStory.count).to eq count + 1
    end

    it "should copy acceptance criteria and tasks" do
      task1 = @us.tasks.create!(definition: Faker::Lorem.sentence, done: false)
      task2 = @us.tasks.create!(definition: Faker::Lorem.sentence, done: true)
      2.times { @us.acceptance_criteria.create(:detail => "It should work") }
      @us.reload
      @us.copy!
      us = UserStory.last
      expect(us.tasks.count).to eq 2
      expect(us.acceptance_criteria.count).to eq 2
    end
  end
end
