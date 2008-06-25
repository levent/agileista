require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImpedimentsController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe "#index" do
    before(:each) do
      stub_login_and_account_setup
    end
    
    it "should get all the impediments" do
      @account.should_receive(:impediments).and_return('impediments')
      get :index
      assigns[:impediments].should == 'impediments'
    end
  end
end
