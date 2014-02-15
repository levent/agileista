require 'spec_helper'

describe Task do

  before(:each) do
    @task = Task.new
  end

  describe "named_scopes" do
    before(:each) do
      @task1 = Task.make!
      @task2 = Task.make!
      @task3 = Task.make!
      @task3.team_members = [Person.make!]
      @task4 = Task.make!(done: true)
    end

    describe "incomplete" do
      it "should get all incomplete tasks" do
        Task.incomplete.should include(@task1)
        Task.incomplete.should include(@task2)
        Task.incomplete.should_not include(@task3)
        Task.incomplete.should_not include(@task4)
      end
    end

    describe "inprogress" do
      it "should get all inprogress tasks" do
        Task.inprogress.should include(@task3)
        Task.inprogress.should_not include(@task1)
        Task.inprogress.should_not include(@task2)
        Task.inprogress.should_not include(@task4)
      end
    end

    describe "complete" do
      it "should get all complete tasks" do
        Task.complete.should include(@task4)
      end
    end

    describe "not_done" do
      it "should get all not done tasks" do
        Task.not_done.should include(@task1, @task2, @task3)
      end
    end
  end

  context "#team_members" do
    before(:each) do
      @task = Task.make
    end

    it "should return an array of team_members assigned to this task" do
      @task.team_members.should be_blank
      @team_member1 = Person.make
      @team_member2 = Person.make
      @task.team_members << @team_member1
      @task.team_members << @team_member2
      @task.team_members.should == [@team_member1, @team_member2]
    end
  end

  describe "inprogress?" do
    it "should be true if any team_members and not done" do
      @task = Task.new(:done => false)
      @task.stub!(:team_members).and_return(["a developer"])
      @task.should be_inprogress
    end


    it "should be false if no team_members and not done" do
      @task = Task.new(:done => true)
      @task.should_not be_inprogress
    end
  end
end
