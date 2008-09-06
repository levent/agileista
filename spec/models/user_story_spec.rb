require File.dirname(__FILE__) + '/../spec_helper'

describe UserStory do
  
  before(:each) do
    @us = UserStory.new
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
      @us.account = Account.create!(:name => 'account', :subdomain => 'subby')
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
      UserStory.find(:all).last.definition.should == "definition - (1st copy)"
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
  
  describe "#unique_definition" do
    it "should add nth copy onto copy of orginal until valid or 25 attempts (which is case in this test)" do
      @us.stub!(:valid?).and_return(false)
      @us.errors.stub!(:on).and_return('false')
      @us.definition = "Some user story for me to test"
      @us.unique_definition.should == "Some user story for me to test - (24th copy)"
    end
    
    describe "with another user story of same name" do
      it "should create 1st copy" do
        @us.definition = "Some user story for me to test"
        @us.account_id = 100
        @us.save.should be_true
        @us2 = @us.clone
        @us2.valid?.should be_false
        @us2.unique_definition.should == "Some user story for me to test - (1st copy)"
      end
    end
    
    describe "with another copy of user story" do
      it "should create 15th copy" do
        @us.definition = "Some user story for me to test - (14th copy)"
        @us.account_id = 100
        @us.save.should be_true
        @us2 = @us.clone
        @us2.valid?.should be_false
        @us2.unique_definition.should == "Some user story for me to test - (15th copy)"
      end
    end
  end
end