require File.dirname(__FILE__) + '/../spec_helper'

describe UserStoriesController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe "#destroy" do
    it "should get user_story first" do
      stub_login_and_account_setup
      controller.stub!(:must_be_team_member)
      @account.user_stories.should_receive(:find).with('16')
      delete :destroy, :id => '16'
    end
  end
  
  describe '#untheme' do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:must_be_team_member)
    end
    
    it 'should set user_story' do
      @account.user_stories.should_receive(:find).with('16')
      post :untheme, :id => '16'
    end
    
    it 'should untheme the user_story' do
      user_story = UserStory.new
      theming = Theming.new
      # @account.user_stories.themings.should_receive(:find_by_theme_id).with('56').and_return(theme)
      @account.user_stories.stub!(:find).and_return(user_story)
      user_story.themings.should_receive(:find_by_theme_id).with('56').and_return(theming)
      theming.should_receive(:destroy).and_return(true)
      post :untheme, :id => '16', :theme_id => '56'
      response.should be_redirect
      response.should redirect_to(themes_path)
    end
  end
  
  describe 'routing' do
    it "should generate params from POST /user_stories/43/untheme correctly" do
      params_from(:post, '/user_stories/43/untheme').should == {:controller => 'user_stories', :action => 'untheme', :id => '43'}
    end
  end
end