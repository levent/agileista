require 'spec_helper'

describe SprintsHelper do
  include ApplicationHelper
  include SprintsHelper

  before(:each) do
    @it = helper
    @account = Account.make!
    @sprint = Sprint.make!(:account => @account)
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
      result.should include("<span class=\"tab\">#{@sprint.name}</span>")
    end

    it "should display the date if asked to" do
      @it.sprint_header(@sprint, :show_date? => true).should include('<span class="hightlight">START to END</span>')
    end

    it "should display the buttons which we're passing only if current_user is a Person and sprint is not finished" do
      @it.stub!(:current_user).and_return(Person.new)
      @sprint.stub!(:finished?).and_return(false)
      result = @it.sprint_header(@sprint, :buttons => [:edit, :plan, :add_story])
      result.should include("<a href=\"http://test.host/sprints/#{@sprint.id}/edit\" class=\"button\">Edit</a>")
      result.should include("<a href=\"http://test.host/sprints/#{@sprint.id}/edit\" class=\"button\">Plan</a>")
      result.should include("<a href=\"http://test.host/sprints/#{@sprint.id}/user_stories/new\" class=\"button\">Add story</a>")
    end

  end
end

