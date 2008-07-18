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
end