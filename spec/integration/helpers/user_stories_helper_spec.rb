require 'spec_helper'

describe UserStoriesHelper do
  include UserStoriesHelper

  before(:each) do
    @it = helper
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

  describe "#parse_definition" do
    it "should convert tags" do
      @us.definition = "[PO] As a user I wanna go home"
      @it.parse_definition(@us.definition).should == '<a href="/backlog/search?q=%5BPO%5D" class="tagged">[PO]</a> As a user I wanna go home'.html_safe
    end

    it "should convert multiple tags" do
      @us.definition = "[PO] [BUG] As a user I wanna go home"
      @it.parse_definition(@us.definition).should == '<a href="/backlog/search?q=%5BPO%5D" class="tagged">[PO]</a> <a href="/backlog/search?q=%5BBUG%5D" class="tagged">[BUG]</a> As a user I wanna go home'.html_safe
    end

    it "should convert multiple joined tags" do
      @us.definition = "[PO][BUG] As a user I wanna go home"
      @it.parse_definition(@us.definition).should == '<a href="/backlog/search?q=%5BPO%5D" class="tagged">[PO]</a><a href="/backlog/search?q=%5BBUG%5D" class="tagged">[BUG]</a> As a user I wanna go home'.html_safe
    end

    it "should handle duplicate tags" do
      @us.definition = "[PO][PO] As a user I wanna go home"
      @it.parse_definition(@us.definition).should == '<a href="/backlog/search?q=%5BPO%5D" class="tagged">[PO]</a><a href="/backlog/search?q=%5BPO%5D" class="tagged">[PO]</a> As a user I wanna go home'.html_safe
    end

    it "should not convert non tagged definitions" do
      @us.definition = "As a user I wanna go home"
      @it.parse_definition(@us.definition).should == 'As a user I wanna go home'
    end

    it "should handle escaping other dodgy tags" do
      @us.definition = "[PO] As a user I wanna go <title>home</title>"
      @it.parse_definition(@us.definition).should == '<a href="/backlog/search?q=%5BPO%5D" class="tagged">[PO]</a> As a user I wanna go &lt;title&gt;home&lt;/title&gt;'.html_safe
    end
  end
end

