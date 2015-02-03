require 'rails_helper'

RSpec.feature 'Deleting a project', type: :feature do

  before do
    user = create_person
    @project = create_project(user)
    login_as(user)
  end

  it "deletes a project" do
    visit "/projects/#{@project.id}/edit"
    click_link 'Delete project'
    expect(page).to have_content 'Project removed'
  end
end
