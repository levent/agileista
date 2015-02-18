require 'rails_helper'

RSpec.describe Task, type: :model do
  it {should validate_presence_of(:user_story)}

  before do
    @task = Task.new
  end

  context "#team_members" do
    before do
      @task = create_task
      @team_member1 = create_person
      @team_member2 = create_person
    end

    it "should return an array of team_members assigned to this task" do
      @task.team_members << @team_member1
      @task.team_members << @team_member2
      expect(@task.team_members).to include @team_member1
      expect(@task.team_members).to include @team_member2
    end
  end

  describe "inprogress?" do
    it "should be true if any team_members and not done" do
      @task = create_task
      @task.team_members << create_person
      expect(@task).to be_inprogress
    end


    it "should be false if no team_members and not done" do
      @task = Task.new(:done => true)
      expect(@task).not_to be_inprogress
    end
  end

  describe "#hours" do
    it "should return 0 if done" do
      task = Task.new
      task.done = true
      expect(task.hours).to eq 0
    end

    it "should return 1 if not done" do
      expect(Task.new.hours).to eq 1
    end
  end
end
