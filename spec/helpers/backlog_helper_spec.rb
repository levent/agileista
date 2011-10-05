require File.dirname(__FILE__) + '/../spec_helper'

describe BacklogHelper do
  include BacklogHelper

  before(:each) do
    @it = self
  end
  
  describe "#release_marker" do
    it "should give you release_marker class if velocity met" do
      @it.release_marker(10, 8).should == ' release_marker'
    end

    it "should give you release_marker class if velocity matched" do
      @it.release_marker(10, 10).should == ' release_marker'
    end

    it "should return nothing if velocity not met" do
      @it.release_marker(10, 11).should == ''
    end

    it "should return nothing if no velocity" do
      @it.release_marker(10, nil).should == ''
    end
  end
  
end
