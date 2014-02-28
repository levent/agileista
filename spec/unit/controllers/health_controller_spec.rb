require 'unit_helper'
require 'action_controller'
require 'health_controller'

describe HealthController do
  describe "#index" do
    before do
      @rails = class_double("Rails").as_stubbed_const
      @rails.stub(:root).and_return('/tmp')
    end

    it "should send okay" do
      health = HealthController.new
      health.index
      health.status.should == 200
      health.response_body.should == ['OK']
    end

    it "should 404 if down for maintenance" do
      File.should_receive(:exist?).with('/tmp/MAINTENANCE').and_return(true)
      health = HealthController.new
      health.index
      health.status.should == 404
      health.response_body.should == ['Not Found']
    end
  end
end
