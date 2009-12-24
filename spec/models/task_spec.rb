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
end