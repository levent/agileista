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
end