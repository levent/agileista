require File.dirname(__FILE__) + '/../spec_helper'

describe ThemesController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe '#index' do
    before(:each) do
      stub_login_and_account_setup
    end

    it "should load all the account themes" do
      @account.themes.should_receive(:find).with(:all, {:order=>"themes.position, user_stories.position", :include=>[:user_stories]})
      get :index
    end
  end
  
  describe '#sort' do
    before(:each) do
      stub_login_and_account_setup
    end

    it "should load all the account themes" do
      @account.themes.should_receive(:find).with(:all, {:order=>"themes.position, user_stories.position", :include=>[:user_stories]}).and_return([])
      post :sort
    end
  end
  
  describe '#destroy' do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @theme = Theme.new
    end
    
    it "should destroy and redirect to themes with flash on success" do
      @account.themes.should_receive(:find).with('123').and_return(@theme)
      @theme.should_receive(:destroy).and_return(true)
      post :destroy, :id => '123'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should be_nil
      flash[:notice].should_not be_nil
    end    
    
    it "should destroy and redirect to themes with flash on fail" do
      @account.themes.should_receive(:find).with('123').and_return(@theme)
      @theme.should_receive(:destroy).and_return(false)
      post :destroy, :id => '123'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should_not be_nil
      flash[:notice].should be_nil
    end
  end
  
end
