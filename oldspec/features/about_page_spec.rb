require 'spec_helper'

describe "about Agileista" do

  it "should be home for non logged in users" do
    visit "/"
    page.should have_content 'Online collaboration for distributed Scrum teams'
  end

  it "should redirect from home to projects for logged in users" do
    user = login_a_user
    visit "/"
    page.should have_link 'Create your first project'
    current_path.should == '/projects'
  end

  it "should allow viewing for logged in users" do
    user = login_a_user
    visit "/about"
    page.should have_content 'Online collaboration for distributed Scrum teams'
  end
end
