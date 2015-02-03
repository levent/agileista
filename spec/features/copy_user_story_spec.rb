
require 'rails_helper'

RSpec.feature 'Copying a user story', type: :feature do

  before do
    @user = create_person
    @project = create_project(@user)
    @sprint = create_sprint(@project)
    @user_story = create_user_story(@project)
    @user_story.sprint = @sprint
    @user_story.save!
    SprintElement.create!(user_story: @user_story, sprint: @sprint)
    login_as(@user)

    visit "/projects/#{@project.id}/sprints/#{@sprint.id}/review"
    click_link 'Copy to Backlog'
  end

  it "copies to backlog" do
    visit "/projects/#{@project.id}/backlog"
    expect(page).to have_content @user_story.definition
  end

  it "should be a new story" do
    visit "/projects/#{@project.id}/backlog"
    expect(page).to have_no_content "##{@user_story.id}"
  end
end
