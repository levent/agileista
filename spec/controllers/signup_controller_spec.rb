require File.dirname(__FILE__) + '/../spec_helper'

describe SignupController do
  it "should NOT be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_false
  end
  
  describe "create" do
    SubdomainFu.mirrors.each do |mirror|
      it "should not allow account with subdomain #{mirror}" do
        Account.should_receive(:new).exactly(0).times
        post :create, :account => {:name => mirror}
        response.should be_redirect
      end
    end
  end
end