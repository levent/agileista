require 'unit_helper'
require 'user_stories_helper'

describe UserStoriesHelper do
  include UserStoriesHelper

  def content_tag(tag, body, options = {})
    "<#{tag} class=\"#{options[:class]}\">#{body}</#{tag}>"
  end

  before do
    @us = fire_double("UserStory")
    @person = fire_double("Person")
    @person.stub(:name).and_return("Some Bo-Di")
  end

  describe "#show_user" do
    it "should return by Unknown if no creator" do
      @us.stub(:person)
      show_user(@us).should == "by Unknown"
    end

    it "should return by Creator if creator" do
      @us.stub(:person).and_return(@person)
      show_user(@us).should == "by Some Bo-Di"
    end
  end

  describe "#user_story_status" do
    it "should return Cannot be estimated if so" do
      @us.should_receive(:cannot_be_estimated?).and_return(true)
      user_story_status(@us).should == "Cannot be estimated"
    end

    it "should return Unestimated if so" do
      @us.should_receive(:cannot_be_estimated?).and_return(false)
      @us.should_receive(:story_points).and_return(nil)
      user_story_status(@us).should == "Unestimated"
    end

    it "should return OK if so" do
      @us.should_receive(:cannot_be_estimated?).and_return(false)
      @us.should_receive(:story_points).and_return(34)
      user_story_status(@us).should == "OK"
    end
  end
end
