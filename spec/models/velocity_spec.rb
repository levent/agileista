require 'spec_helper'

describe Velocity do

  describe "confidence_interval" do
    it "should require at least five values" do
      Velocity.confidence_interval([1,2,3,4]).should be_nil
    end

    it "should return the correct interval" do
      ci = Velocity.confidence_interval([17, 18, 20, 20, 21, 23, 23, 27])
      ci.first.to_i.should == 18
      ci.last.to_i.should == 23
      ci.size.should == 2
    end
  end

  describe ".stats_significant_since_sprint_id" do
    it "should check Redis for first significant sprint" do
      REDIS.should_receive(:get).with("account:19:stats_since:sprint_id")
      Velocity.stats_significant_since_sprint_id(19)
    end
  end
end
