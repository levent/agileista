require File.dirname(__FILE__) + '/../spec_helper'

describe NotificationMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  describe "#password_reminder" do
    before do
      @account_holder = Person.new(:name => 'boss@leventali.com')
      @account = Account.new(:subdomain => 'subdomain', :name => "woot", :account_holder => @account_holder)
      @user = Person.new(:email => 'me@leventali.com')
      @email = NotificationMailer.password_reminder(@user, @account, 'absecure').deliver
    end

    it "should remind a user" do
      @email.to.should include('me@leventali.com')
      @email.subject.should == '[Agileista] This should help you login'
      @email.body.should include("Here's your new password: absecure")
      @email.body.should include("http://subdomain.agileista.local/login")
    end
  end

  describe "#account_invitation" do
    before do
      @account_holder = Person.new(:name => 'boss@leventali.com')
      @account = Account.new(:subdomain => 'subdomain', :name => "woot", :account_holder => @account_holder)
      @user = Person.new(:email => 'me@leventali.com')
      @email = NotificationMailer.account_invitation(@user, @account, 'absecure').deliver
    end

    it "should invite a user" do
      @email.to.should include('me@leventali.com')
      @email.subject.should == '[Agileista] Get Started!'
      @email.body.should include("Hi you've been invited to join Agileista by boss@leventali.com")
      @email.body.should include("http://subdomain.agileista.local/validate")
    end
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
