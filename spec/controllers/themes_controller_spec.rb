require File.dirname(__FILE__) + '/../spec_helper'

describe ThemesController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe '#index' do
    before(:each) do
      stub_login_and_account_setup
    end

    it "should load all the account themese" do
      @account.themes.should_receive(:find).with(:all, {:order=>"themes.name, user_stories.position", :include=>[:user_stories]})
      get :index
    end
  end
end