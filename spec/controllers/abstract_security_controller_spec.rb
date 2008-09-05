require File.dirname(__FILE__) + '/../spec_helper'

describe AbstractSecurityController do
  it "should be an application_controller" do
    controller.is_a?(ApplicationController).should be_true
  end
  
  describe "must be logged in" do
    it "should redirect to login if login fails" do
      controller.should_receive(:logged_in?).and_return(false)
      get :must_be_logged_in
      response.should be_redirect
    end
  end
end