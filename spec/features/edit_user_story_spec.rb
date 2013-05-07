require 'spec_helper'

describe "editing a user story" do

  before do
    @user = login_a_user
    @project = create_project_for(@user)
    @user_story = create_user_story_for(@project)
  end

  it "edits a user story" do
    visit "/projects/#{@project.id}/user_stories/#{@user_story.id}/edit"
    fill_in 'user_story_definition', :with => 'As a user I want beef to eat'
    click_button 'Update User story'
    page.should have_content 'User story updated successfully'
    page.should have_content 'As a user I want beef to eat'
  end

  it "should prefill stakeholder" do
    visit "/projects/#{@project.id}/user_stories/#{@user_story.id}/edit"
    page.should have_css("#user_story_stakeholder[value=\"#{@user.name}\"]")
  end
end
