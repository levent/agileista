require File.dirname(__FILE__) + '/../spec_helper'

describe TasksController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end

  describe "route recognition" do
    it "should generate params from POST /agile/sprints correctly" do
      params_from(:post, '/agile/user_stories/8/tasks').should == {:controller => 'tasks', :action => 'create', :account_name => 'agile', :user_story_id => '8'}
    end
    
    it "should generate params from GET /agile/tasks correctly" do
      params_from(:get, '/agile/user_stories/8/tasks').should == {:controller => 'tasks', :action => 'index', :account_name => 'agile', :user_story_id => '8'}
    end
    
    it "should generate params from POST /agile/tasks/7/claim correctly" do
      params_from(:post, '/agile/user_stories/8/tasks/7/claim').should == {:controller => 'tasks', :action => 'claim', :account_name => 'agile', :id => '7', :user_story_id => '8'}
    end
    
    it "should generate params from POST /agile/tasks/7/release correctly" do
      params_from(:post, '/agile/user_stories/8/tasks/7/release').should == {:controller => 'tasks', :action => 'release', :account_name => 'agile', :id => '7', :user_story_id => '8'}
    end
    
    it "should generate params from POST /agile/tasks/7/move_up correctly" do
      params_from(:post, '/agile/user_stories/8/tasks/7/move_up').should == {:controller => 'tasks', :action => 'move_up', :account_name => 'agile', :id => '7', :user_story_id => '8'}
    end
    
    it "should generate params from POST /agile/tasks/7/move_down correctly" do
      params_from(:post, '/agile/user_stories/8/tasks/7/move_down').should == {:controller => 'tasks', :action => 'move_down', :account_name => 'agile', :id => '7', :user_story_id => '8'}
    end
    
    it "should generate params from DELETE /agile/tasks/7 correctly" do
      params_from(:delete, '/agile/user_stories/8/tasks/7').should == {:controller => 'tasks', :action => 'destroy', :account_name => 'agile', :id => '7', :user_story_id => '8'}
    end
  end

end