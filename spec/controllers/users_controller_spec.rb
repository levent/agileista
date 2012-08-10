require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe 'create' do
    before(:each) do
      stub_login_and_account_setup_properly
      # controller.stub!(:must_be_account_holder).and_return(true)
    end
    
    it "should set temp password and email it" # do
     #      @it = Person.new
     #      @it.stub!(:account=)
     #      @it.stub!(:valid?).and_return(true)
     #      Person.should_receive(:new).and_return(@it)
     #      @it.should_receive(:generate_temp_password).and_return('tempass')
     #      NotificationMailer.should_receive(:deliver_account_invitation).with(@it, nil, 'tempass', controller)
     #      post :create, :person => {:name => 'name', :email => 'email@example.com'}, :type => 'team_member'
     #    end
  end
  
  context "listing users" do
    before(:each) do
      stub_login_and_account_setup_properly
      # controller.stub!(:must_be_account_holder).and_return(true)
    end
    
    it "should return all the account users and render a list" do
      controller.stub!(:current_user).and_return(@person)
      team_member = Person.make(:account => @account)
      get :index
      assigns(:users).should include(team_member)
      assigns(:users).should include(contributor)
    end
  end
end
