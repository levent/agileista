require File.dirname(__FILE__) + '/../spec_helper'

describe Task do
  
  before(:each) do
    @task = Task.new
  end

  describe "named_scopes" do
    before(:each) do
      @task1 = Task.make!(:hours => 100)
      @task2 = Task.make!(:hours => 1)
      @task3 = Task.make!(:hours => 14)
      @task3.team_members = [Person.make!]
      @task4 = Task.make!(:hours => 0)
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

  describe "incomplete?" do
    it "should be false if any team_members are assigned" do
      @task = Task.new
      @task.stub!(:team_members).and_return(["a developer"])
      @task.should_not be_incomplete
    end

    it "should be true if any hours left" do
      @task = Task.new(:hours => 100)
      @task.should be_incomplete
    end

    it "should be true if nil hours left" do
      @task = Task.new(:hours => nil)
      @task.should be_incomplete
    end

    it "should be false if no hours are left" do
      @task = Task.new(:hours => 0)
      @task.should_not be_incomplete
    end
  end

  describe "inprogress?" do
    it "should be true if any team_members and hours left" do
      @task = Task.new(:hours => 1)
      @task.stub!(:team_members).and_return(["a developer"])
      @task.should be_inprogress
    end

    it "should be true if any team_members and nil hours left" do
      @task = Task.new(:hours => nil)
      @task.stub!(:team_members).and_return(["a developer"])
      @task.should be_inprogress
    end

    it "should be false if no team_members and hours left" do
      @task = Task.new(:hours => 1)
      @task.should_not be_inprogress
    end

    it "should be false if no team_members and nil hours left" do
      @task = Task.new(:hours => nil)
      @task.should_not be_inprogress
    end
  end

end
