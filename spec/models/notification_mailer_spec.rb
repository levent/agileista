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
      @email = NotificationMailer.new_account_on_agileista(@account).deliver
    end
  
    it "should be sent to team agileista" do
      @email.to.should include("lebreeze@gmail.com")
    end
    
    it "should have a subject" do
      @email.subject.should == "[AGILEISTA ADMIN] There has been a new account registration"
    end
    
    it "should have the account details" do
      @email.body.should == <<XML
Account Name: woot
Subdomain: subdomain

Account Holder: 
Account Holder Email: 

XML
    end
  end
end
