require "rails_helper"

RSpec.feature "Editing a user story", type: :feature do

  before do
    @user = create_person
    @project = create_project(@user)
    @user_story = create_user_story(@project)
    login_as(@user)
  end

  it "edits a user story" do
    visit "/projects/#{@project.id}/user_stories/#{@user_story.id}/edit"
    fill_in "user_story_definition", with: "As a user I want beef to eat"
    click_button "Save and Close"
    expect(page).to have_content "User story updated successfully"
    expect(page).to have_content "As a user I want beef to eat"
  end

  it "fails if someone else edits in the meantime" do
    error = ActiveRecord::StaleObjectError.new(@user_story, :update)
    allow_any_instance_of(UserStory).
      to receive(:update_attributes).and_raise(error)
    visit "/projects/#{@project.id}/user_stories/#{@user_story.id}/edit"
    fill_in "user_story_definition", with: "As a user I want beef to eat"
    click_button "Save and Close"
    expect(page).to have_content "Another person has just updated that record"
  end

  it "should prefill stakeholder" do
    visit "/projects/#{@project.id}/user_stories/#{@user_story.id}/edit"
    expect(page).to have_css("#user_story_stakeholder[value=\"#{@user.name}\"]")
  end

  context "planning poker" do
    it "should show when unestimated" do
      visit "/projects/#{@project.id}/user_stories/#{@user_story.id}/edit"
      expect(page).to have_content "Planning Poker"
    end

    it "should hide when estimated" do
      @user_story.update_attribute(:story_points, 13)
      visit "/projects/#{@project.id}/user_stories/#{@user_story.id}/edit"
      expect(page).to have_no_content "Planning Poker"
    end
  end
end
