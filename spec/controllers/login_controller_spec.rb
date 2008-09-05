require File.dirname(__FILE__) + '/../spec_helper'

describe LoginController do
  it "should NOT be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_false
  end
  
  describe "#authenticate" do    
    before(:each) do
      @account = Account.new
      @person = Person.new(:authenticated => '1', :email => 'leemail')
      controller.stub!(:current_user).and_return(@person)
    end
    
    it "should redirect if no account found" do
      controller.stub!(:current_subdomain).and_return('nonexistent')
      Account.should_receive(:find_by_name).with('nonexistent').and_return(nil)
      get :authenticate
      response.should render_template('login/index')
    end
    
    it "should attempt to log user in if account provided" do
      controller.stub!(:current_subdomain).and_return('existent')
      controller.stub!(:logged_in?).and_return(false)
      Account.should_receive(:find_by_name).with('existent').and_return(@account)
      @account.should_receive(:authenticate).with('l', 'dog').and_return(nil)
      get :authenticate, :email => 'l', :password => 'dog'
    end
    
    it "should switch accounts if logged_in and member of other account" do
      controller.stub!(:current_subdomain).and_return('existent')
      controller.should_receive(:logged_in?).and_return(true)
      Account.should_receive(:find_by_name).with('existent').and_return(@account)
      @account.people.should_receive(:find).with(:first, :conditions => ["email = ? AND authenticated = ?", 'leemail', 1]).and_return(nil)
      get :authenticate
    end
  end
end