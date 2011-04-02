require File.dirname(__FILE__) + '/../spec_helper'

describe SprintsHelper do
  include ApplicationHelper
  include SprintsHelper

  before(:each) do
    @it = self
    stub_sprint
  end

  describe "#identify_key_sprint" do
    it "should return current sprint class if so" do
      @sprint.should_receive(:current?).and_return(true)
      @it.identify_key_sprint(@sprint).should include("currentsprint")
    end

    it "should return upcoming sprint class if so" do
      @sprint.should_receive(:current?).and_return(false)
      @sprint.should_receive(:upcoming?).and_return(true)
      @it.identify_key_sprint(@sprint).should include("upcomingsprint")
    end

    it "should return empty string if old sprint" do
      @sprint.should_receive(:current?).and_return(false)
      @sprint.should_receive(:upcoming?).and_return(false)
      @it.identify_key_sprint(@sprint).should == ""
    end
  end

  describe "#sprint_header" do
    before(:each) do
      @it.stub!(:current_user).and_return(false)

      @it.stub!(:show_date).with(@sprint.start_at).and_return('START')
      @it.stub!(:show_date).with(@sprint.end_at).and_return('END')
    end

    it "should display the sprint name" do
      result = @it.sprint_header(@sprint)
      result.should have_tag('span.tab', "Sprint A")
      result.should_not have_tag('span.hightlight', "START to END.")
    end

    it "should display the date if asked to" do
      @it.sprint_header(@sprint, :show_date? => true).should have_tag('span.hightlight', "START to END")
    end

    it "should display number of allocated sp if asked to" do
      user_story = UserStory.make
      user_story.sprint = @sprint
      user_story.story_points = 18
      user_story.save!
      @sprint.account = Account.make

      SprintElement.create!(:user_story => user_story, :sprint => @sprint)
      @it.sprint_header(@sprint, :show_story_points? => true).should have_tag('span.hightlight', /0 out of 18 story points completed/) do
        with_tag('strong', "0")
        with_tag('strong', "18")
      end
    end

    it "should not display buttons by default" do
      @it.stub!(:current_user).and_return(TeamMember.new)
      response = @it.sprint_header(@sprint)
      response.should_not have_tag('a.button')
    end

    it "should display the buttons which we're passing only if current_user is a TeamMember and sprint is not finished" do
      @it.stub!(:current_user).and_return(TeamMember.new)
      @sprint.stub!(:finished?).and_return(false)
      @it.sprint_header(@sprint, :buttons => [:edit, :plan, :add_story]).should have_tag('span.tab', /Sprint A/) do
        with_tag('a.button:nth-of-type(1)', "Edit")
        with_tag('a.button:nth-of-type(2)', "Plan")
        with_tag('a.button:nth-of-type(3)', "Add story")
      end
    end

  end
end

