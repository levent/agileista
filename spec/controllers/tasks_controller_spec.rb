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
    
    # Still some legacy actions
    # TasksController.instance_methods(false).each do |action|
    %w(edit update destroy create_quick assign).each do |action|
      it "should set_user_story on '#{action}'" do
        controller.should_receive(:set_user_story).and_raise(ActiveRecord::RecordNotFound)
        lambda {get action.to_sym}.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    %w(edit update destroy).each do |action|
      it "should set_task on '#{action}'" do
        controller.stub!(:set_user_story).and_return(@user_story)
        controller.should_receive(:set_task).and_raise("whoa")
        lambda {get action.to_sym}.should raise_error("whoa")
      end
    end
  end
  
  describe 'destroy' do
    before(:each) do
      stub_login_and_account_setup
      @user_story = UserStory.new
      @task = Task.new
      @account.user_stories.stub!(:find).and_return(@user_story)
      @user_story.tasks.stub!(:find).and_return(@task)
    end
    
    it "should destroy task and redirect on success" do
      @task.should_receive(:destroy).and_return(true)
      delete :destroy, :id => '79'      
    end
  end
  
  describe 'create_quick' do
    before(:each) do
      stub_login_and_account_setup
      @user_story = UserStory.new
      @task = Task.new
      @user_story.stub!(:id).and_return(1)
      @user_story.stub!(:sprint_id).and_return(1)
      @user_story.stub!(:definition).and_return("us definition")
      @user_story.stub!(:description).and_return("us description")
      @account.user_stories.should_receive(:find).and_return(@user_story)
    end
    
    it "should create task from user story" do
      @user_story.tasks.should_receive(:new).with(:definition => "us definition", :description => "us description", :hours => 6).and_return(@task)
      @task.should_receive(:save).and_return(true)
      post :create_quick, :user_story_id => '98'
      response.should be_redirect
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
    
    it "should update task and redirect on success" do
      @task.should_receive(:update_attributes).with('hash').and_return(true)
      put :update, :task => 'hash'
      response.should be_redirect
      response.should redirect_to(edit_user_story_url(@user_story, :anchor => "user_story_tasks"))
    end
    
    it "should update task and redirect to taskboard on success with parameter" do
      @task.should_receive(:update_attributes).with('hash').and_return(true)
      put :update, :task => 'hash', :from => 'tb'
      response.should be_redirect
      response.should redirect_to(edit_user_story_url(@user_story, :anchor => "user_story_tasks"))
    end
    
    it "should update task and redirect on fail" do
      @task.should_receive(:update_attributes).with('hash').and_return(false)
      controller.should_receive(:render).with(:action => 'edit')
      put :update, :task => 'hash'
    end
  end
  
  describe 'new' do
    before(:each) do
      stub_login_and_account_setup
      @user_story = UserStory.new
      @task = Task.new
      @user_story.stub!(:id).and_return(1)
      @task.stub!(:id).and_return(1)
      @account.user_stories.should_receive(:find).and_return(@user_story)
      # @user_story.tasks.should_receive(:find).and_return(@task)
    end
  end

end
