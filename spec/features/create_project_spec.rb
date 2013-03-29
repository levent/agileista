require 'spec_helper'

describe "adding a new project" do
  include Warden::Test::Helpers
  Warden.test_mode!

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
end
