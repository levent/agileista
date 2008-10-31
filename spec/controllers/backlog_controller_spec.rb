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
      UserStory.should_receive(:search).with("find me carrots", :with => {:account_id => 78}).and_return(@results)
      post :search, :q => 'find me carrots'
    end
    
    it "should raise exception if no account_id" do
      @account.stub!(:id).and_return(nil)
      @results.stub!(:results).and_return([])
      UserStory.should_receive(:search).exactly(0).times
      lambda {post :search, :q => 'find me carrots'}.should raise_error(ArgumentError)
    end
  end
end