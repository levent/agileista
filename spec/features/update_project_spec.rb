require 'rails_helper'

RSpec.feature 'Changing a project', type: :feature do

  before do
    user = create_person
    @project = create_project(user)
    login_as(user)
  end

  it "updates a project" do
    visit "/projects/#{@project.id}/edit"
    fill_in 'Name', :with => 'New Project Name'
    select '4 weeks', :from => 'Iteration length'
    click_button 'Update Project'
    expect(page).to have_content 'Project settings saved'
  end

  it "fails to update a project" do
    visit "/projects/#{@project.id}/edit"
    select '', :from => 'Iteration length'
    click_button 'Update Project'
    expect(page).to have_content "Project settings couldn't be saved"
  end

  it "allows changing use_estimates" do
    visit "/projects/#{@project.id}/edit"
    uncheck 'Use estimates'
    click_button 'Update Project'
    expect(page).to have_content 'Project settings saved'
  end

  it "creates hipchat settings" do
    visit "/projects/#{@project.id}/edit"
    fill_in 'hip_chat_integration_token', :with => 'abcd'
    fill_in 'Room', :with => 'Room1'
    check 'Notify'
    click_button 'Save HipChat Settings'
    expect(page).to have_content "Settings saved"
  end

  it "creates slack settings" do
    visit "/projects/#{@project.id}/edit"
    fill_in 'slack_integration_token', :with => 'abcd'
    fill_in 'Team', :with => 'Agileista'
    fill_in 'Channel', :with => 'agileista'
    check 'Notify'
    click_button 'Save Slack Settings'
    expect(page).to have_content "Settings saved"
  end

  context 'with existing integration settings' do
    before do
      HipChatIntegration.create!(project: @project)
      SlackIntegration.create!(project: @project)
    end

    it "updates hipchat settings" do
      visit "/projects/#{@project.id}/edit"
      fill_in 'hip_chat_integration_token', :with => 'abcd'
      fill_in 'Room', :with => 'Room1'
      check 'Notify'
      click_button 'Save HipChat Settings'
      expect(page).to have_content "Settings updated"
    end

    it "updates slack settings" do
      visit "/projects/#{@project.id}/edit"
      fill_in 'slack_integration_token', :with => 'abcd'
      fill_in 'Team', :with => 'Agileista'
      fill_in 'Channel', :with => 'agileista'
      check 'Notify'
      click_button 'Save Slack Settings'
      expect(page).to have_content "Settings updated"
    end
  end
end
