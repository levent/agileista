require 'rails_helper'

RSpec.feature 'Creating a user story', type: :feature do

  before do
    @user = create_person
    @project = create_project(@user)
    login_as(@user)
  end

  it "creates a user story" do
    visit "/projects/#{@project.id}/user_stories/new"
    fill_in 'user_story_definition', :with => 'As a user I want beef to eat'
    click_button 'Save and Close'
    expect(page).to have_content 'User story created'
    expect(page).to have_content 'As a user I want beef to eat'
  end

  it "should prefill stakeholder" do
    visit "/projects/#{@project.id}/user_stories/new"
    expect(page).to have_css("#user_story_stakeholder[value=\"#{@user.name}\"]")
  end

  context 'with use estimates turned off' do
    before do
      @project.update_attribute(:use_estimates, false)
    end

    it "creates a user story"
  end
end
