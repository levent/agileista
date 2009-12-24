require File.dirname(__FILE__) + '/../spec_helper'

describe UserStoriesHelper do
  include UserStoriesHelper

  before(:each) do
    @it = self
    @us = UserStory.new
  end

  describe "#show_user" do
    it "should return by Unknown if no creator" do
      @it.show_user(@us).should == "by Unknown"
    end

    it "should return by Creator if creator" do
      @us.person = Person.new(:name => "Some Bo-Di")
      @it.show_user(@us).should == "by Some Bo-Di"
    end
  end

  describe "#user_story_status" do
    it "should return Cannot be estimated if so" do
      @us.should_receive(:cannot_be_estimated?).and_return(true)
      @it.user_story_status(@us).should == "Cannot be estimated"
    end

    it "should return Unestimated if so" do
      @us.should_receive(:cannot_be_estimated?).and_return(false)
      @us.should_receive(:story_points).and_return(nil)
      @it.user_story_status(@us).should == "Unestimated"
    end

    it "should return OK if so" do
      @us.should_receive(:cannot_be_estimated?).and_return(false)
      @us.should_receive(:story_points).and_return(34)
      @it.user_story_status(@us).should == "OK"
    end
  end
end

