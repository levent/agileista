require File.dirname(__FILE__) + '/../spec_helper'

describe LoginController do
  it "should NOT be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_false
  end
end
