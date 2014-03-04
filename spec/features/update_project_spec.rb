require 'spec_helper'

describe "changing a project" do

  before do
    user = login_a_user
    @project = create_project_for(user)
  end

  it "updates a project" do
    visit "/projects/#{@project.id}/edit"
    fill_in 'Name', :with => 'New Project Name'
    select '4 weeks', :from => 'Iteration length'
    click_button 'Update Project'
    page.should have_content 'Project settings saved'
  end

  it "fails to update a project" do
    visit "/projects/#{@project.id}/edit"
    select '', :from => 'Iteration length'
    click_button 'Update Project'
    page.should have_content "Project settings couldn't be saved"
  end

  it "creates hipchat settings" do
    visit "/projects/#{@project.id}/edit"
    fill_in 'hip_chat_integration_token', :with => 'abcd'
    fill_in 'Room', :with => 'Room1'
    check 'Notify'
    click_button 'Save HipChat Settings'
    page.should have_content "HipChat settings saved"
  end

  it "creates slack settings" do
    visit "/projects/#{@project.id}/edit"
    fill_in 'slack_integration_token', :with => 'abcd'
    fill_in 'Team', :with => 'Agileista'
    fill_in 'Channel', :with => 'agileista'
    check 'Notify'
    click_button 'Save Slack Settings'
    page.should have_content "Slack settings saved"
  end
end
