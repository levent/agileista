require File.dirname(__FILE__) + '/../spec_helper'

describe TasksController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
end