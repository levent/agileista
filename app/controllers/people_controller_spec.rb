require 'spec_helper'

describe PeopleController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
end
