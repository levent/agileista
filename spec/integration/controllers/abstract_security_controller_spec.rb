require 'spec_helper'

describe AbstractSecurityController do
  it "should be an application_controller" do
    controller.is_a?(ApplicationController).should be_true
  end
end
