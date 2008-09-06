require File.dirname(__FILE__) + '/../spec_helper'

describe SprintsController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe "before filters" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:create_chart)
    end

    SprintsController.instance_methods(false).each do |action|
      it "should ensure iteration length specified for action #{action}" do
        @account.should_receive(:iteration_length).and_return([])
        get action.to_sym
        response.should be_redirect
        response.should redirect_to(:action => 'settings', :controller => 'account')
      end
    end
    
    %w(plan edit new update create).each do |action|
      it "should only allow team members on '#{action}" do
        controller.should_receive(:must_be_team_member).and_return(false)
        get action.to_sym
      end
    end
    
    %w(show overview edit plan update).each do |action|
      it "should set sprint on '#{action}'" do
        controller.stub!(:must_be_team_member).and_return(true)
        controller.stub!(:iteration_length_must_be_specified).and_return(true)
        controller.should_receive(:sprint_must_exist).and_return(@sprint)
        get action.to_sym
      end
    end
  end
  
  describe "#new" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      controller.stub!(:must_be_team_member).and_return(true)
      @sprint = Sprint.new
    end
    
    it "should instantiate object" do
      @account.sprints.should_receive(:new).and_return(@sprint)
      get :new
      assigns(:sprint).should == @sprint
    end
  end
  
  describe "#plan" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @sprint = Sprint.new
    end
    
    it "should render 404 if sprint finished" do
      @account.sprints.stub!(:find).and_return(@sprint)
      @sprint.should_receive(:finished?).and_return(true)
      controller.expect_render(:file => "#{RAILS_ROOT}/public/404.html", :status => 404)
      get :plan
    end
    
    it "shouldn't render 404 if active or future sprint" do
      @account.sprints.stub!(:find).and_return(@sprint)
      @sprint.should_receive(:finished?).and_return(false)
      get :plan
      response.should be_success
    end
  end
  
  describe "#index" do
    before(:each) do
      stub_login_and_account_setup
    end
    
    describe "after before filters" do
      before(:each) do
        stub_iteration_length_and_create_chart
      end

      it "should load all the sprints" do
        @account.should_receive(:sprints).and_return(['sprint'])
        get :index
        assigns[:sprints].should == ['sprint']
      end
    end
  end
  
  describe "#create" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @sprint = Sprint.new
    end

    it "should create sprint and redirect on success" do
      @account.sprints.should_receive(:new).with('sprinthash').and_return(@sprint)
      @sprint.should_receive(:save).and_return(true)
      post :create, :sprint => 'sprinthash'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
    end
    
    it "should create sprint and redirect on fail" do
      @account.sprints.should_receive(:new).with('sprinthash').and_return(@sprint)
      @sprint.should_receive(:save).and_return(false)
      controller.expect_render(:action => 'new')
      post :create, :sprint => 'sprinthash'
    end
    
    it "should calculate start date if blank" do
      @sprint.account.should_receive(:iteration_length).and_return(2)
      @sprint.start_at = nil
      @account.sprints.stub!(:new).and_return(@sprint)
      post :create, :from => {:year => '2008', :month => '4', :day => '1'}
    end
  end
  
  describe "#update" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @sprint = Sprint.new
    end
    
    it "should update sprint and redirect on success" do
      @account.sprints.should_receive(:find).and_return(@sprint)
      @sprint.should_receive(:update_attributes).with('sprinthash').and_return(true)
      post :update, :sprint => 'sprinthash'
      response.should be_redirect
      response.should redirect_to :action => 'index'
    end
    
    it "should update sprint and redirect on fail" do
      @account.sprints.should_receive(:find).and_return(@sprint)
      @sprint.should_receive(:update_attributes).with('sprinthash').and_return(false)
      controller.expect_render(:action => 'edit')
      post :update, :sprint => 'sprinthash'
    end
  end
  
  describe "#show" do
    before(:each) do
      stub_login_and_account_setup
    end
    
    describe "after before filters" do
      before(:each) do
        stub_iteration_length_and_create_chart
      end
    
      it "should ensure sprint exists" do
        @sprint = Sprint.new(:start_at => 1.months.ago, :end_at => 2.weeks.ago)
        @account.sprints.should_receive(:find).with('23').and_return(@sprint)
        get :show, :id => 23
        assigns[:sprint].should == @sprint
        assigns[:current_sprint].should == @sprint
      end
    
      describe "by loading a real sprint" do
        before(:each) do
          @sprint = Sprint.new
          @account.sprints.should_receive(:find).with('23').and_return(@sprint)          
        end
        
        it "should call create_chart" do
          @sprint.should_receive(:current?).and_return(false)
          controller.should_receive(:create_chart).exactly(1).times
          get :show, :id => 23
        end

        it "should render show_task_board if current sprint and calc burndown" do
          @sprint.should_receive(:current?).and_return(true)
          controller.should_receive(:calculate_tomorrows_burndown).exactly(1).times
          get :show, :id => 23
          response.should render_template("sprints/task_board")
        end

        it "should render show if not current sprint and NOT calc burndown" do
          @sprint.should_receive(:current?).and_return(false)
          controller.should_receive(:calculate_tomorrows_burndown).exactly(0).times
          get :show, :id => 23
          response.should render_template("sprints/show")
        end
      end    
    end
  end
  
  describe "route recognition" do
    it "should generate params from GET /agile/sprints correctly" do
      params_from(:get, '/sprints').should == {:controller => 'sprints', :action => 'index'}
    end
    
    it "should generate params from POST /agile/sprints correctly" do
      params_from(:post, '/sprints').should == {:controller => 'sprints', :action => 'create'}
    end
    
    it "should generate params from GET /agile/sprints/7/plan correctly" do
      params_from(:get, '/sprints/7/plan').should == {:controller => 'sprints', :action => 'plan', :id => '7'}
    end
    
    it "should generate params from DELETE /agile/sprints/7 correctly" do
      params_from(:delete, '/sprints/7').should == {:controller => 'sprints', :action => 'destroy', :id => '7'}
    end
    
    it "should generate params from GET /agile/sprints/7/overview correctly" do
      params_from(:get, '/sprints/7/overview').should == {:controller => 'sprints', :action => 'overview', :id => '7'}
    end
  end
end