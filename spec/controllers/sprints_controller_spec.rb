require File.dirname(__FILE__) + '/../spec_helper'

describe SprintsController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe "#index" do
    before(:each) do
      stub_login_and_account_setup
    end
    
    it "should load all the sprints" do
      @account.should_receive(:sprints).and_return(['sprint'])
      get :index
      assigns[:sprints].should == ['sprint']
    end
  end
  
  describe "route recognition" do
    it "should generate params from GET /agile/sprints correctly" do
      params_from(:get, '/agile/sprints').should == {:controller => 'sprints', :action => 'index', :account_name => 'agile'}
    end
    
    it "should generate params from POST /agile/sprints correctly" do
      params_from(:post, '/agile/sprints').should == {:controller => 'sprints', :action => 'create', :account_name => 'agile'}
    end
    
    it "should generate params from GET /agile/sprints/7/plan correctly" do
      params_from(:get, '/agile/sprints/7/plan').should == {:controller => 'sprints', :action => 'plan', :account_name => 'agile', :id => '7'}
    end
    # it "should generate params from POST /session correctly" do
    #   params_from(:post, '/session').should == {:controller => 'sessions', :action => 'create'}
    # end
    it "should generate params from DELETE /agile/sprints/7 correctly" do
      params_from(:delete, '/agile/sprints/7').should == {:controller => 'sprints', :action => 'destroy', :account_name => 'agile', :id => '7'}
    end
  end
end