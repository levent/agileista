require 'rails_helper'

RSpec.feature 'Viewing a sprint', type: :feature do

  before do
    user = create_person
    @project = create_project(user)
    @sprint = create_sprint(@project)
    login_as(user)
  end

  it "viewing a sprint" do
    visit "/projects/#{@project.id}/sprints/#{@sprint.id}"
    expect(page).to have_content @sprint.name
  end
end
