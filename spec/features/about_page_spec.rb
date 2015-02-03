require 'rails_helper'

RSpec.feature 'About Agileista', type: :feature do

  scenario "should be home for non logged in users" do
    visit "/"
    expect(page).to have_content 'Online collaboration for distributed Scrum teams'
  end

  context "with a logged in user" do
    before do
      @person = create_person
    end

    scenario "should redirect from home to projects for logged in users" do
      visit '/people/sign_in'
      fill_in 'person_email', with: @person.email
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      expect(current_path).to eq '/projects'
      expect(page).to have_link 'Create your first project'
    end

    scenario "should allow viewing for logged in users" do
      visit "/about"
      expect(page).to have_content 'Online collaboration for distributed Scrum teams'
    end
  end
end
