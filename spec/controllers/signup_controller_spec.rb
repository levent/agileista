require File.dirname(__FILE__) + '/../spec_helper'

describe SignupController do
  it "should NOT be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_false
  end
  
  describe "create" do
    AccountStuff::RESERVED_SUBDOMAINS.each do |subdomain|
      it "should not allow account with subdomain #{subdomain}" do
        Account.should_receive(:new).exactly(0).times
        post :create, :account => {:subdomain => subdomain}
        response.should be_redirect
      end
    end
    
    # it "should email team agileista" do
    #   post :create, :account => {:subdomain => 'somethingunique'}
    # end
  end
end