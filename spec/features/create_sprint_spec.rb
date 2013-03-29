require 'spec_helper'

describe "creating a sprint" do

  before do
    user = login_a_user
    @project = create_project_for(user)
  end

  it "creates a sprint" do
    visit "/projects/#{@project.id}/sprints/new"
    fill_in 'Name', :with => 'My First Sprint'
    click_button 'Create Sprint'
    page.should have_content 'Sprint created'
  end

  it "fails to create a sprint" do
    visit "/projects/#{@project.id}/sprints/new"
    click_button 'Create Sprint'
    page.should have_content 'Sprint could not be created'
  end
end
