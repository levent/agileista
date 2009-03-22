require File.dirname(__FILE__) + '/../spec_helper'

describe BetaEmailsController do
  it "should not be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_false
  end

  describe "index" do
    it "should render new" do
      get :index
      response.should render_template('beta_emails/new.html.erb')      
    end
  end
  
  describe "create" do
    it "should store the email" do
      lambda {post :create, :beta_email => {:email => "tneville@neville.org"}}.should change(BetaEmail, :count).by(1)
      BetaEmail.last.email.should == "tneville@neville.org"
    end
  end
end