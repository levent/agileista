require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  before(:each) do
    @it = self
    @us = UserStory.new
  end

  describe "show_story_points" do
    it "should give you an informative message on how many story points a story is worth" do
      @it.show_story_points(13).should == "13 story points"
    end

    it "should inform user if story points aren't defind" do
      @it.show_story_points(nil).should == "? story points"
    end
  end
  
  describe "show_assignees" do
    before(:each) do
      @task = Task.make
    end
    
    it "should show the names of assigned developers" do
      team_member1 = Person.make
      team_member2 = Person.make
      team_member3 = Person.make
      @task.developers = [team_member3, team_member2, team_member1]
      @it.show_assignees(@task.developers).should == "#{team_member3.name}, #{team_member2.name}, #{team_member1.name}"
    end
    
    it "should show nobody if blank" do
      @it.show_assignees(@task.developers).should == "Nobody"
    end
  end

  describe "#complete?" do
    it "should return class if user_story is complete" do
      @us.stub!(:complete?).and_return(true)
      @it.complete?(@us).should == " class=\"uscomplete\""
    end
  end

  describe "#claimed?" do
    it "should return class if user_story is inprogress?" do
      @us.stub!(:inprogress?).and_return(true)
      @it.claimed?(@us).should == " class=\"usclaimed\""
    end
  end

  describe "#claimed_or_complete?" do
    it "should return uscomplete class if user_story is complete and not inprogress" do
      @us.stub!(:complete?).and_return(true)
      @us.stub!(:inprogress?).and_return(false)
      @it.claimed_or_complete?(@us).should == " class=\"uscomplete\""
    end

    it "should return uscomplete class if user_story is complete and inprogress" do
      #even though this is impossible?
      @us.stub!(:complete?).and_return(true)
      @us.stub!(:inprogress?).and_return(true)
      @it.claimed_or_complete?(@us).should == " class=\"uscomplete\""
    end

    it "should return usclaimed class if user_story is not complete and inprogress" do
      #even though this is impossible?
      @us.stub!(:complete?).and_return(false)
      @us.stub!(:inprogress?).and_return(true)
      @it.claimed_or_complete?(@us).should == " class=\"usclaimed\""
    end
  end

  describe "#show_stakeholder" do
    # deals with legacy before created_by
    it "should return by Unknown if no stakeholder or creator" do
      @it.show_stakeholder(@us).should == "Unknown"
    end

    it "should return by Creator if no stakeholder" do
      @us.person = Person.new(:name => 'monkey face')
      @it.show_stakeholder(@us).should == "monkey face"
    end

    it "should return by stakeholder if provided" do
      # @us.person = Person.new(:name => 'monkey face')
      @us.stakeholder = "fred dude"
      @it.show_stakeholder(@us).should == "fred dude"
    end

    it "should return by stakeholder if provided even if creator also there" do
      @us.person = Person.new(:name => 'monkey face')
      @us.stakeholder = "fred dude"
      @it.show_stakeholder(@us).should == "fred dude"
    end

    it "should display blank if unprovided and false passed into 2nd param" do
      @us.person = Person.new(:name => 'monkey face')
      # @us.stakeholder = "fred dude"
      @it.show_stakeholder(@us, false).should == "Unknown"
    end
  end

  describe "#page_signature" do
    before(:each) do
      @it.stub!(:current_user).and_return(false)
      @it.stub!(:current_sprint).and_return(false)
      @params = {:controller => "happy", :action => "feet"}
    end

    it "should display controller_name & action_name" do
      @it.page_signature(@params).should == 'happy feet'
    end

    it "should display authenticated if user is logged in" do
      @it.stub!(:current_user).and_return(true)
      @it.page_signature(@params).should include("authenticated")
    end

    describe "if we're viewing a sprint" do
      before(:each) do
        stub_sprint
        @it.stub!(:current_sprint).and_return(@sprint)
      end

      it "should display task_board when we're viewing the current_sprint" do
        @params = {:controller => "sprints", :action => "show", :id => "1"}
        @it.page_signature(@params).should include("task_board")
      end

      it "should not display task_board if we're on any other sprint" do
        @params = {:controller => "sprints", :action => "show", :id => "2"}
        @it.page_signature(@params).should_not include("task_board")
      end
    end
  end

  describe "#flash_messages" do
    it "should not display anything if :error or :notice have not been set" do
      @it.flash_messages.should == nil
    end

    it "should display both the error and notice messages if they are present" do
      flash[:error] = "some error"
      flash[:notice] = "some notice"
      @it.flash_messages.should have_tag("div.flash") do
        with_tag("h3.notice", "some notice")
        with_tag("h3.error", "some error")
      end
    end

    it "should use another the wrapping tag that was set" do
      flash[:error] = "some error"
      @it.flash_messages("p").should have_tag("div.flash") do
        with_tag("p.error", "some error")
      end
    end
  end

  describe "#main_navigation" do
    before(:each) do
      @it.stub!(:unresolved_impediment_indicator).and_return("resolved")
      @it.stub!(:current_user).and_return(true)
      @account = Account.new
    end

    it "should contain the main pages by default" do
      @it.main_navigation.should have_tag("ul") do
        with_tag("li.backlog a", "Backlog")
        with_tag("li.themes a", "Themes")
        with_tag("li.sprints a", "Sprints")
        with_tag("li.impediments a.resolved", "Impediments")
      end
    end

    it "should mark the impediments link as unresolved" do
      @it.stub!(:unresolved_impediment_indicator).and_return("unresolved")
      @it.main_navigation.should have_tag("a.unresolved", "Impediments")
    end

    it "should include a task board link if there is a current sprint" do
      @it.stub!(:current_sprint).and_return(1)
      @it.main_navigation.should have_tag("li.task_board a", "Task Board")
    end
  end

  describe "#user_navigation" do
    before(:each) do
      @it.stub!(:current_user).and_return(true)
    end

    it "should contain 2 links by default" do
      @it.stub!(:current_sprint).and_return(false)
      @it.user_navigation.should have_tag("ul") do
        with_tag("li.account a", "Account")
        with_tag("li.logout a", "Logout")
      end
    end
  end

  describe "#active?" do
    before(:each) do
      @it.stub!(:current_user).and_return(true)
    end

    it "should match arrays" do
      @it.stub!(:page_signature).and_return("backlog index")
      match = ["backlog", "new"]
      @it.active?(match).should == true
    end

    it "should match strings" do
      @it.stub!(:page_signature).and_return("backlog index")
      match = "backlog"
      @it.active?(match).should == true
    end
  end

  describe "#user_story_state" do
    it "should have specific format based on user story state" do
      @it.user_story_state("plan").should have_tag("span.plan", "Plan")
    end
   end
end

