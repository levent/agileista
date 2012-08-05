require 'spec_helper'

describe Velocity do

  describe "confidence_interval" do
    it "should require at least five values" do
      Velocity.confidence_interval([1,2,3,4]).should be_nil
    end

    it "should return the correct interval" do
      Velocity.confidence_interval([17, 18, 20, 20, 21, 23, 23, 27]).should ==
        "fds"
    end
  end
end
