require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImpedimentsController do
  before(:each) do
    stub_login_and_account_setup
  end

  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe "#index" do
    it "should get all the impediments" do
      impediments = Object.new
      @account.should_receive(:impediments).and_return(impediments)
      impediments.stub!(:paginate).and_return('impediments')
      get :index
      assigns[:impediments].should == 'impediments'
    end
  end
  
  describe '#active' do
    it "should get all the active impediments" do
      impediments = Object.new
      @account.impediments.should_receive(:unresolved).and_return(impediments)
      impediments.stub!(:paginate).and_return('impediments')
      get :active
      assigns[:impediments].should == 'impediments'
    end
    
    it "should render index.html.erb" do
      impediments = Object.new
      @account.impediments.stub!(:unresolved).and_return(impediments)
      impediments.stub!(:paginate).and_return('impediments')
      get :active
      response.should render_template('impediments/index')
    end
  end
  
  describe "#new" do
    it "should set up new impediment" do
      @account.impediments.should_receive(:new).and_return('newimpediment')
      get :new
      assigns[:impediment].should == 'newimpediment'
    end
  end
  
  describe "#create" do
    before(:each) do
      @impediment = Impediment.new
    end
    
    it "should try and create an impediment" do
      @account.impediments.should_receive(:new).with('description' => 'punk face').and_return(@impediment)
      post :create, :impediment => {:description => 'punk face'}
    end
    
    it "should assign current_user to the impediment" do
      @account.impediments.stub!(:new).and_return(@impediment)
      @impediment.should_receive(:team_member=).with(@person)
      post :create, :impediment => {:description => 'punk face'}
    end
    
    it "should redirect to index on success" do
      @account.impediments.stub!(:new).and_return(@impediment)
      @impediment.should_receive(:save).and_return(true)
      post :create, :impediment => {:description => 'punk face'}
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should be_nil
      flash[:notice].should_not be_nil
    end
    
    it "should render new form on fail" do
      @account.impediments.stub!(:new).and_return(@impediment)
      @impediment.should_receive(:save).and_return(false)
      post :create, :impediment => {:description => 'punk face'}
      response.should be_success
      response.should render_template("impediments/new")
      flash[:error].should_not be_nil
      flash[:notice].should be_nil
    end
  end
  
  describe "#destroy" do
    it "should destroy an impediment if current user is reporter of it" do
      @impediment = Impediment.new(:team_member => @person)
      @account.impediments.should_receive(:find).with('89').and_return(@impediment)
      @impediment.should_receive(:destroy).and_return(true)
      delete :destroy, :id => '89'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should be_nil
      flash[:notice].should_not be_nil
    end
    
    it "should NOT destroy an impediment if reported by someone else" do
      @impediment = Impediment.new(:team_member => TeamMember.new)
      @account.impediments.should_receive(:find).with('89').and_return(@impediment)
      @impediment.should_not_receive(:destroy)
      delete :destroy, :id => '89'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should_not be_nil
      flash[:notice].should be_nil
    end
  end
  
  describe "#resolve" do
    it "should resolve impediment" do
      @impediment = Impediment.new(:team_member => @person)
      @account.impediments.should_receive(:find).with('67').and_return(@impediment)
      @impediment.should_receive(:resolve).and_return(true)
      post :resolve, :id => '67'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should be_nil
      flash[:notice].should_not be_nil
    end
    
    it "should inform user if resolving impediment failed" do
      @impediment = Impediment.new(:team_member => @person)
      @account.impediments.should_receive(:find).with('67').and_return(@impediment)
      @impediment.should_receive(:resolve).and_return(false)
      post :resolve, :id => '67'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should_not be_nil
      flash[:notice].should be_nil
    end
  end
  
  describe "routing" do
    it "should be set up for resolving impediments" do
      params_from(:post, "/impediments/1/resolve").should == {:controller => "impediments", :action => 'resolve', :id =>'1'}
    end
    
    it "should have an active action" do
      params_from(:get, "/impediments/active").should == {:controller => "impediments", :action => 'active'}
    end
  end
end
