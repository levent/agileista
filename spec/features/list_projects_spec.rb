require 'rails_helper'

RSpec.feature 'Listing projects', type: :feature do
  let(:user) { create_person }

  before do
    @project = create_project(user)
    login_as(user)
  end

  it "listing when only one project" do
    visit '/projects'
    expect(page).to have_content @project.name.humanize
    expect(current_path).to eq '/projects'
  end

  it "should tell me if I have been added to a project" do
    new_project = create_project
    Invitation.create!(project: new_project, email: user.email)
    visit '/projects'
    expect(page).to have_content 'You have been invited to participate in additional projects'
  end
end
