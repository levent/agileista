require File.dirname(__FILE__) + '/../spec_helper'

describe TasksController do
  before(:each) do
    request.env["HTTP_REFERER"] = "http://test.host"
  end
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe 'before_filters' do
    before(:each) do
      stub_login_and_account_setup
      @user_story = UserStory.new
      @task = Task.new
    end
    
    TasksController.instance_methods(false).each do |action|
      it "should only allow team members on '#{action}" do
        controller.should_receive(:must_be_team_member).and_return(false)
        get action.to_sym
      end
    end
    
    # Still some legacy actions
    # TasksController.instance_methods(false).each do |action|
    %w(show edit update destroy).each do |action|
      it "should set_user_story on '#{action}'" do
        controller.stub!(:must_be_team_member).and_return(true)
        controller.should_receive(:set_user_story).and_return(@user_story)
        get action.to_sym
      end
    end
    
    %w(show edit update destroy).each do |action|
      it "should set_task on '#{action}'" do
        controller.stub!(:must_be_team_member).and_return(true)
        controller.stub!(:set_user_story).and_return(@user_story)
        controller.should_receive(:set_task).and_return(@task)
        get action.to_sym
      end
    end
  end
  
  describe 'update' do
    before(:each) do
      stub_login_and_account_setup
      @user_story = UserStory.new
      @task = Task.new
      @user_story.stub!(:id).and_return(1)
      @task.stub!(:id).and_return(1)
      @account.user_stories.should_receive(:find).and_return(@user_story)
      @user_story.tasks.should_receive(:find).and_return(@task)
    end
    
    it "should update sprint and redirect on success" do
      @task.should_receive(:update_attributes).with('hash').and_return(true)
      put :update, :task => 'hash'
      response.should be_redirect
    end
    
    it "should update sprint and redirect on fail" do
      @task.should_receive(:update_attributes).with('hash').and_return(false)
      controller.expect_render(:action => 'edit')
      put :update, :task => 'hash'
    end
  end

  describe "route recognition" do
    it "should generate params from POST /sprints correctly" do
      params_from(:post, '/user_stories/8/tasks').should == {:controller => 'tasks', :action => 'create', :user_story_id => '8'}
    end
    
    it "should generate params from GET /tasks correctly" do
      params_from(:get, '/user_stories/8/tasks').should == {:controller => 'tasks', :action => 'index', :user_story_id => '8'}
    end
    
    it "should generate params from POST /tasks/7/claim correctly" do
      params_from(:post, '/user_stories/8/tasks/7/claim').should == {:controller => 'tasks', :action => 'claim', :id => '7', :user_story_id => '8'}
    end
    
    it "should generate params from POST /tasks/7/release correctly" do
      params_from(:post, '/user_stories/8/tasks/7/release').should == {:controller => 'tasks', :action => 'release', :id => '7', :user_story_id => '8'}
    end
    
    it "should generate params from POST /tasks/7/move_up correctly" do
      params_from(:post, '/user_stories/8/tasks/7/move_up').should == {:controller => 'tasks', :action => 'move_up', :id => '7', :user_story_id => '8'}
    end
    
    it "should generate params from POST /tasks/7/move_down correctly" do
      params_from(:post, '/user_stories/8/tasks/7/move_down').should == {:controller => 'tasks', :action => 'move_down', :id => '7', :user_story_id => '8'}
    end
    
    it "should generate params from DELETE /tasks/7 correctly" do
      params_from(:delete, '/user_stories/8/tasks/7').should == {:controller => 'tasks', :action => 'destroy', :id => '7', :user_story_id => '8'}
    end
  end

end