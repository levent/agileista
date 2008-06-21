require File.dirname(__FILE__) + '/../spec_helper'

describe LoginController do
  before(:each) do
  end
  
  describe "#authenticate" do
    it "should redirect if no account found" do
      Account.should_receive(:find_by_name).with('nonexistent').and_return(nil)
      controller.should_receive(:setup_account_name_for_form).and_return(true)
      get :authenticate, :account => 'nonexistent'
      response.should render_template('login/index')
    end
    
    it "should attempt to log user in if account provided" do
      @account = Account.new
      Account.should_receive(:find_by_name).with('existent').and_return(@account)
      @account.people.should_receive(:find).with(:first, :conditions => ["email = ? AND password = ? AND authenticated = ?", 'l', 'dog', 1]).and_return(nil)
      get :authenticate, :account => 'existent', :email => 'l', :password => 'dog'
    end
  end
end