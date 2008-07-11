require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImpedimentsController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end

  describe "#index" do
    before(:each) do
      stub_login_and_account_setup
    end
    
    it "should get all the impediments" do
      @account.should_receive(:impediments).and_return('impediments')
      get :index
      assigns[:impediments].should == 'impediments'
    end
  end
  
  describe "#new" do
    before(:each) do
      stub_login_and_account_setup
    end
    
    it "should set up new impediment" do
      @account.impediments.should_receive(:new).and_return('newimpediment')
      get :new
      assigns[:impediment].should == 'newimpediment'
    end
  end
  
  describe "#create" do
    before(:each) do
      @impediment = Impediment.new
      stub_login_and_account_setup
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
      response.should redirect_to :action => 'index'
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
  
  # describe "#destroy" do
  #   before(:each) do
  #     @impediment = Impediment.new
  #     stub_login_and_account_setup
  #   end
  #   
  #   it "should destroy an impediment if current user is reporter of it" do
  #     delete :destroy
  #   end
  # end
end
