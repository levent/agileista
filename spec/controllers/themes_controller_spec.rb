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
  
  describe "route recognition" do
    it "should generate params from GET /themes correctly" do
      params_from(:get, '/themes/new').should == {:controller => 'themes', :action => 'new'}
    end

    it "should generate params from GET /themes correctly" do
      params_from(:get, '/themes').should == {:controller => 'themes', :action => 'index'}
    end
    
    it "should generate params from POST /themes correctly" do
      params_from(:post, '/themes').should == {:controller => 'themes', :action => 'create'}
    end
    
    it "should generate params from PUT /themes/8 correctly" do
      params_from(:put, '/themes/8').should == {:controller => 'themes', :action => 'update', :id => '8'}
    end
    
    it "should generate params from DELETE /themes/7 correctly" do
      params_from(:delete, '/themes/7').should == {:controller => 'themes', :action => 'destroy', :id => '7'}
    end
  end
end