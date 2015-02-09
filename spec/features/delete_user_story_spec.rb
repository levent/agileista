require 'rails_helper'

RSpec.feature 'Deleting user stories', type: :feature do

  let(:person) { create_person }
  let(:project) { create_project(person) }

  context 'deleting one by one' do
    before do
      @user_story = create_user_story(project)
      login_as(person)
      visit "/projects/#{project.id}/backlog"
      click_link 'Delete'
    end

    it "should inform me it has succeeded" do
      expect(page).to have_content 'User story deleted'
    end

    it "should have gotten rid of the story" do
      expect(page).to have_no_content @user_story.definition
    end
  end

  context 'deleting multiple' do

    before do
      3.times { create_user_story(project) }
      login_as(person)
    end

    it "allows deleting multiple user stories" do
      visit "/projects/#{project.id}/backlog"
      project.user_stories.each do |us|
        find(:css, "#user_stories_delete_#{us.id}").set(true)
      end
      click_button 'Delete selected'
      expect(page).to have_content 'Create your first user story'
    end
  end
end
