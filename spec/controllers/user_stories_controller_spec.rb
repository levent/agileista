require File.dirname(__FILE__) + '/../spec_helper'

describe UserStoriesController do
  
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe "#destroy" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:must_be_team_member)
    end
    
    it "should get user_story first" do
      @account.user_stories.should_receive(:find).with('16').and_raise(ActiveRecord::RecordNotFound)
      lambda {delete :destroy, :id => '16'}.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  context "viewing a story" do
    before(:each) do
      stub_login_and_account_setup_properly
    end
    
    it "should redirect to sprint scope if story is assigned to one" do
      sprint = Sprint.make(:account => @account)
      user_story = UserStory.make(:sprint => sprint, :account => @account)
      # SprintElement.find_or_create_by_sprint_id_and_user_story_id(sprint.id, user_story.id)
      
      get :show, :id => user_story.id
      response.should be_redirect
      response.should redirect_to(sprint_user_story_url(sprint, user_story))
    end
    
    it "should not go redirect crazy if story is assigned to sprint and url already reflects this" do
      sprint = Sprint.make(:account => @account)
      user_story = UserStory.make(:sprint => sprint, :account => @account)
      # SprintElement.find_or_create_by_sprint_id_and_user_story_id(sprint.id, user_story.id)
      
      get :show, :id => user_story.id
      response.should be_redirect
      response.should redirect_to(sprint_user_story_url(sprint, user_story))
    end
    
  end
end