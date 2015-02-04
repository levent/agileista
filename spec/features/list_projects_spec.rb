require 'rails_helper'

RSpec.feature 'Listing projects', type: :feature do

  before do
    user = create_person
    @project = create_project(user)
    login_as(user)
  end

  it "listing when only one project" do
    visit '/projects'
    expect(page).to have_content @project.name.humanize
    expect(current_path).to eq '/projects'
  end
end
