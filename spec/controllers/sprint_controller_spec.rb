require File.dirname(__FILE__) + '/../spec_helper'

describe SprintController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe "#update_hours" do
    before(:each) do
      stub_login_and_account_setup
      request.env["HTTP_REFERER"] = 'http://test.local'
      @person = TeamMember.new(:authenticated => '1', :email => 'leemail')
      @task = Task.new
      controller.stub!(:setup_account_variables)
      controller.stub!(:current_user).and_return(@person)
      Task.should_receive(:find).with('198').and_return(@task)
    end
    
    it "should not update task if current_user is not responsible for task" do
      @task.should_not_receive(:save)
      post :update_hours, :id => '198'
      flash[:error].should_not be_nil
    end
    
    it "should update task if owned by current_user" do
      @task.developer = @person
      @task.should_receive(:save).and_return(true)
      post :update_hours, :id => '198'
      flash[:error].should be_nil
    end
  end
end