require File.dirname(__FILE__) + '/../spec_helper'

describe BacklogController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end

  describe "#search" do
    before(:each) do
      stub_login_and_account_setup
      @results = [UserStory.new]
    end
    
    it "should scope to active and current account user stories" do
      @account.stub!(:id).and_return(78)
      @results.stub!(:results).and_return([])
      UserStory.should_receive(:search).with("find me carrots", :with => {:account_id => 78}, :limit => 1000, :page => '13', :per_page => 20).and_return(@results)
      get :search, :q => 'find me carrots', :page => '13'
    end
    
    it "should raise exception if no account_id" do
      @account.stub!(:id).and_return(nil)
      @results.stub!(:results).and_return([])
      UserStory.should_receive(:search).exactly(0).times
      lambda {post :search, :q => 'find me carrots'}.should raise_error(ArgumentError)
    end
  end

  describe "index#stale" do
    it "should be routed by /backlog/stale" do
      params_from(:get, '/backlog/stale').should == {:controller => 'backlog', :action => 'index', :filter => 'stale'}
    end

    it "should filter out the recent stories" do
      stub_login_and_account_setup
      @account.user_stories.make
      stale = @account.user_stories.make
      stale.updated_at = 3.years.ago
      stale.save!
      get :index, :filter => 'stale'
      assigns(:user_stories).should == @account.user_stories.unassigned('position').stale(1.month.ago)
      assigns(:user_stories).should_not include(stale)
    end
  end
end
