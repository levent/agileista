require File.dirname(__FILE__) + '/../spec_helper'

describe AccountController do
  before(:each) do
    stub_login_and_account_setup
  end
  
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end

  describe 'index' do
    it "should redirect to settings" do
      get :index
      response.should be_redirect
      response.should redirect_to(:action => 'settings')
    end
  end
  
  describe 'settings' do
    it "should do nothing to account on get" do
      @account.should_receive(:update_attributes).exactly(0).times
      get :settings, :account => {:nothing => 'important'}
      response.should be_success
    end

    it "should update account and redirect to backlog on success" do
      @account.should_receive(:update_attributes).with({'nothing' => 'important'}).and_return(true)
      post :settings, :account => {:nothing => 'important'}
      response.should be_redirect
      response.should redirect_to(:controller => 'backlog')
    end
    
    it "should try update account and render settings on fail" do
      @account.should_receive(:update_attributes).with({'nothing' => 'important'}).and_return(false)
      post :settings, :account => {:nothing => 'important'}
      response.should be_success
    end
  end
  
  describe 'change_password' do
    before(:each) do
      @person.email = 'monkey@example.com'
    end
    
    it "should validate with old password before attempting change" do
      # controller.should_receive(:logged_in?).and_return(true)
      @person.account.should_receive(:authenticate).with('monkey@example.com', 'oldpass').and_return(@person)
      @person.should_receive(:update_attributes).with({:password => "newpass", :password_confirmation => "newpass"}).and_return(true)
      post :change_password, :old_password => 'oldpass', :new_password => 'newpass', :new_password_confirmation => 'newpass'
    end
    
    it "should not change password if old pass is invalid" do
      # controller.should_receive(:logged_in?).and_return(true)
      @person.account.should_receive(:authenticate).with('monkey@example.com', 'oldpass').and_return(nil)
      @person.should_receive(:update_attributes).exactly(0).times
      post :change_password, :old_password => 'oldpass', :new_password => 'newpass', :new_password_confirmation => 'newpass'
    end
  end
end