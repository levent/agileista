require File.dirname(__FILE__) + '/../spec_helper'

describe AcceptanceCriteriaController do
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
      @acceptance_criterion = AcceptanceCriterium.new
    end
    
    AcceptanceCriteriaController.instance_methods(false).each do |action|
      it "should only allow team members on '#{action}" do
        controller.should_receive(:must_be_team_member).and_raise(ActiveRecord::RecordNotFound)
        lambda {get action.to_sym}.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    # Still some legacy actions
    # TasksController.instance_methods(false).each do |action|
    %w(update destroy create).each do |action|
      it "should set_user_story on '#{action}'" do
        controller.stub!(:must_be_team_member).and_return(true)
        controller.should_receive(:set_user_story).and_raise(ActiveRecord::RecordNotFound)
        controller.stub!(:set_acceptance_criterion)
        lambda {get action.to_sym}.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    %w(update destroy).each do |action|
      it "should set_acceptance_criterion on '#{action}'" do
        controller.stub!(:must_be_team_member).and_return(true)
        controller.stub!(:set_user_story)
        controller.should_receive(:set_acceptance_criterion).and_raise(ActiveRecord::RecordNotFound)
        lambda {get action.to_sym}.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'create' do
    before(:each) do
      stub_login_and_account_setup
      @user_story = UserStory.new
      @acceptance_criterion = AcceptanceCriterium.new
      @user_story.stub!(:id).and_return(1)
      @user_story.stub!(:sprint_id).and_return(1)
      @account.user_stories.should_receive(:find).and_return(@user_story)
    end
    
    it "should create acceptance criterium and render partial" do
      @user_story.acceptance_criteria.should_receive(:new).with('hash').and_return(@acceptance_criterion)
      @acceptance_criterion.should_receive(:save).and_return(true)
      controller.should_receive(:render).with(:partial => 'user_stories/acceptance_criteria')
      post :create, :acceptance_criterion => 'hash', :format => 'json'
    end
  end
  
  describe 'destroy' do
    before(:each) do
      stub_login_and_account_setup
      @user_story = UserStory.new
      @acceptance_criterion = AcceptanceCriterium.new
      @user_story.stub!(:id).and_return(1)
      @user_story.stub!(:sprint_id).and_return(1)
      @account.user_stories.should_receive(:find).and_return(@user_story)
      @user_story.acceptance_criteria.stub!(:find).and_return(@acceptance_criterion)
    end
    
    it "should find the acceptance criterion" do
      @user_story.acceptance_criteria.should_receive(:find).with("17").and_return(@acceptance_criterion)
      delete :destroy, :user_story_id => "23", :id => "17"
    end
    
    it "should destroy acceptance criterion and render partial" do
      @acceptance_criterion.should_receive(:destroy)
      controller.should_receive(:render).with(:partial => 'user_stories/acceptance_criteria')
      delete :destroy, :user_story_id => "23", :id => "17", :format => 'json'
    end
  end
  
  describe 'update' do
    before(:each) do
      stub_login_and_account_setup
      @user_story = UserStory.new
      @acceptance_criterion = AcceptanceCriterium.new
      @user_story.stub!(:id).and_return(1)
      @acceptance_criterion.stub!(:id).and_return(1)
      @account.user_stories.should_receive(:find).and_return(@user_story)
      @user_story.acceptance_criteria.stub!(:find).and_return(@acceptance_criterion)
    end
    
    it "should find the acceptance criterion" do
      @user_story.acceptance_criteria.should_receive(:find).with("17").and_return(@acceptance_criterion)
      put :update, :user_story_id => "23", :id => "17"
    end
    
    it "should update acceptance criterion" do
      @acceptance_criterion.should_receive(:update_attribute).with(:detail, 'new ting')
      @controller.should_receive(:render)
      put :update, :user_story_id => "23", :id => "17", :value => 'new ting'
    end
  end
  
  describe "route recognition" do
    it "should generate params from POST /acceptance_criteria correctly" do
      params_from(:post, '/user_stories/8/acceptance_criteria').should == {:controller => 'acceptance_criteria', :action => 'create', :user_story_id => '8'}
    end
    
    it "should generate params from GET /acceptance_criteria correctly" do
      params_from(:get, '/user_stories/8/acceptance_criteria').should == {:controller => 'acceptance_criteria', :action => 'index', :user_story_id => '8'}
    end
    
    it "should generate params from DELETE /acceptance_criteria/7 correctly" do
      params_from(:delete, '/user_stories/8/acceptance_criteria/7').should == {:controller => 'acceptance_criteria', :action => 'destroy', :id => '7', :user_story_id => '8'}
    end
  
    it "should generate params from PUT /acceptance_criteria/7 correctly" do
      params_from(:put, '/user_stories/8/acceptance_criteria/7').should == {:controller => 'acceptance_criteria', :action => 'update', :id => '7', :user_story_id => '8'}
    end
  end
end