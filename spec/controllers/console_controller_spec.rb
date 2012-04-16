require File.dirname(__FILE__) + '/../spec_helper'

describe ConsoleController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  it "should raise error even if you are logged in" do
    stub_login_and_account_setup
    lambda {get :index}.should raise_error
  end
  
  it "should remain if you are levent" do
    @person = TeamMember.new(:email => 'lebreeze@gmail.com')
    @account = Account.new
    @person.account = @account
    session[:user] = 1
    session[:account_subdomain] = 1
    Person.stub!(:find_by_id_and_account_id).and_return(@person)
    
    get :index
    response.should be_success
  end
  
  it "should remain if you are eben" do
    @person = TeamMember.new(:email => 'lebreeze@gmail.com')
    @account = Account.new
    @person.account = @account
    session[:user] = 1
    session[:account_subdomain] = 1
    Person.stub!(:find_by_id_and_account_id).and_return(@person)
    
    get :index
    response.should be_success
  end

end
