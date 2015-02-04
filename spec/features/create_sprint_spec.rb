require 'rails_helper'

RSpec.feature 'Creating a sprint', type: :feature do

  before do
    user = create_person
    @project = create_project(user)
    login_as(user)
  end

  it "creates a sprint" do
    visit "/projects/#{@project.id}/sprints/new"
    fill_in 'Name', :with => 'My First Sprint'
    click_button 'Create Sprint'
    expect(page).to have_content 'Sprint created'
  end

  it "fails to create a sprint" do
    visit "/projects/#{@project.id}/sprints/new"
    click_button 'Create Sprint'
    expect(page).to have_content 'Sprint could not be created'
  end
end
