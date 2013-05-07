require 'spec_helper'

describe ApplicationHelper, :type => :helper do

  before do
    @it = helper
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

    it "should show the names of assigned team_members" do
      team_member1 = Person.make
      team_member2 = Person.make
      team_member3 = Person.make
      @task.team_members = [team_member3, team_member2, team_member1]
      @it.show_assignees(@task.team_members).should == "#{team_member3.name}, #{team_member2.name}, #{team_member1.name}"
    end

    it "should show nobody if blank" do
      @it.show_assignees(@task.team_members).should == "Nobody"
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

    it "should have a user override option" do
      person = Person.new(:name => 'monkey face')
      @it.show_stakeholder(@us, person).should == "monkey face"
    end
  end
end
