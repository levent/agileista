require 'spec_helper'

describe "adding a new project" do

  before do
    login_a_user
  end

  it "creates a project" do
    visit '/projects/new'
    fill_in 'Name', :with => 'Mango'
    select '2 weeks', :from => 'Iteration length'
    click_button 'Create Project'
    page.should have_content 'Project created'
    page.should have_content 'Create your first user story'
  end

  it "fails to create a project" do
    visit '/projects/new'
    click_button 'Create Project'
    page.should have_content 'Project could not be created'
  end
end
