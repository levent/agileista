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
    
    it "should email team agileista" do
      account = Account.new
      user = Person.new
      Account.stub!(:new).and_return(account)
      account.stub!(:save).and_return(true)
      account.stub!(:valid?).and_return(true)
      user.stub!(:save).and_return(true)
      user.stub!(:valid?).and_return(true)
      account.team_members.stub!(:new).and_return(user)
      NotificationMailer.stub!(:deliver_account_activation_info)
      NotificationMailer.should_receive(:deliver_new_account_on_agileista).with(account)
      post :create, :account => {:subdomain => 'somethingunique'}
    end
  end
end
