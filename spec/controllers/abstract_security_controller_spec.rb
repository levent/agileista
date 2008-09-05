require File.dirname(__FILE__) + '/../spec_helper'

describe AbstractSecurityController do
  it "should be an application_controller" do
    controller.is_a?(ApplicationController).should be_true
  end
  
  describe "must be logged in" do
    it "should redirect to signup site (app.agileista.com) if no account for subdomain"
  end
end