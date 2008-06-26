require File.dirname(__FILE__) + '/../spec_helper'

describe UserStory do
  
  before(:each) do
    @us = UserStory.new
    @task_a = Task.new
    @task_b = Task.new
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
  
  describe "#copy" do
    before(:each) do
      @us.account = Account.create!(:name => 'account')
      @us.definition = "definition"
      @us.save!
      @us.save!
    end

    it "should create a new user story" do
      count = UserStory.count
      @us.copy
      UserStory.count.should == count + 1
    end
    
    it "should create a unique definition each time" do
      @us.copy
      UserStory.find(:all).last.definition.should == "definition - (2nd copy)"
      @us.copy
      UserStory.find(:all).last.definition.should == "definition - (3rd copy)"
      @us.copy
      UserStory.find(:all).last.definition.should == "definition - (4th copy)"
      @us.copy
      UserStory.find(:all).last.definition.should == "definition - (5th copy)"
      @us.copy
      UserStory.find(:all).last.definition.should == "definition - (6th copy)"
    end
  end
  
end