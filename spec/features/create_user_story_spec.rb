require 'spec_helper'

describe "creating a user story" do

  before do
    @user = login_a_user
    @project = create_project_for(@user)
  end

  it "creates a user story" do
    visit "/projects/#{@project.id}/user_stories/new"
    fill_in 'user_story_definition', :with => 'As a user I want beef to eat'
    click_button 'Save and Close'
    page.should have_content 'User story created'
    page.should have_content 'As a user I want beef to eat'
  end

  it "should prefill stakeholder" do
    visit "/projects/#{@project.id}/user_stories/new"
    page.should have_css("#user_story_stakeholder[value=\"#{@user.name}\"]")
  end
end
