require File.dirname(__FILE__) + '/../spec_helper'

describe NotificationMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end
  
  describe "new_account_on_agileista" do
    before(:each) do
      @account = Account.new(:subdomain => 'subdomain', :name => "woot")
      @email = NotificationMailer.deliver_new_account_on_agileista(@account)
    end
  
    it "should be sent to team agileista" do
      @email.to.should include("lebreeze@gmail.com")
      @email.to.should include("ebstar@gmail.com")
    end
    
    it "should have a subject" do
      @email.subject.should == "[AGILEISTA ADMIN] There has been a new account registration"
    end
    
    it "should have the account details" do
      @email.body.should == @account.to_yaml
    end
  end
end