require File.dirname(__FILE__) + '/../spec_helper'

describe Task do
  
  before(:each) do
    @task = Task.new
  end
  
  describe "named_scopes" do
    before(:each) do
      @task1 = Task.make(:hours => 100)
      @task2 = Task.make(:hours => 1)
      @task3 = Task.make(:hours => 14)
      @task3.developers = [TeamMember.make]
      @task4 = Task.make(:hours => 0)
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
        expected_options = { :conditions => "hours = 0" }
        assert_equal expected_options, Task.complete.proxy_options
      end
    end
    
    describe "done" do
      it "should get all done tasks" do
        expected_options = { :conditions => "hours = 0" }
        assert_equal expected_options, Task.done.proxy_options
      end
    end
    
    describe "not_done" do
      it "should get all not done tasks" do
        expected_options = { :conditions => "hours > 0 OR hours IS NULL" }
        assert_equal expected_options, Task.not_done.proxy_options
      end
    end
  end
  
  context "developers" do
    before(:each) do
      @task = Task.make
    end
    
    it "should return an array of developers assigned to this task" do
      @task.developers.should be_blank
      @team_member1 = TeamMember.make
      @team_member2 = TeamMember.make
      @task.developers << @team_member1
      @task.developers << @team_member2
      @task.developers.should == [@team_member1, @team_member2]
    end
  end

  describe "incomplete?" do
    it "should be false if any developers are assigned" do
      @task = Task.new
      @task.stub!(:developers).and_return(["a developer"])
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
    it "should be true if any developers and hours left" do
      @task = Task.new(:hours => 1)
      @task.stub!(:developers).and_return(["a developer"])
      @task.should be_inprogress
    end

    it "should be true if any developers and nil hours left" do
      @task = Task.new(:hours => nil)
      @task.stub!(:developers).and_return(["a developer"])
      @task.should be_inprogress
    end

    it "should be false if no developers and hours left" do
      @task = Task.new(:hours => 1)
      @task.should_not be_inprogress
    end

    it "should be false if no developers and nil hours left" do
      @task = Task.new(:hours => nil)
      @task.should_not be_inprogress
    end
  end

end
