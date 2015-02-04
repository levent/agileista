require 'rails_helper'

RSpec.feature 'Deleting user stories', type: :feature do

  before do
    user = create_person
    @project = create_project(user)
    @user_story = create_user_story(@project)
    login_as(user)
    visit "/projects/#{@project.id}/backlog"
    click_link 'Delete'
  end

  it "should inform me it has succeeded" do
    expect(page).to have_content 'User story deleted'
  end

  it "should have gotten rid of the story" do
    expect(page).to have_no_content @user_story.definition
  end
end
