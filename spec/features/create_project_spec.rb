require 'rails_helper'

RSpec.feature 'Creating a project', type: :feature do

  before do
    login_as(create_person)
  end

  it "creates a project" do
    visit '/projects/new'
    fill_in 'Name', with: 'Mango'
    select '2 weeks', from: 'Iteration length'
    click_button 'Create Project'
    expect(page).to have_content 'Project created'
    expect(page).to have_content 'Create your first user story'
  end

  it "fails to create a project" do
    visit '/projects/new'
    click_button 'Create Project'
    expect(page).to have_content 'Project could not be created'
  end

  it "should let user choose no estimates mode" do
    visit '/projects/new'
    fill_in 'Name', with: 'Mango'
    select '2 weeks', from: 'Iteration length'
    uncheck 'Use estimates'
    click_button 'Create Project'
    expect(page).to have_content 'Project created'
  end
end
