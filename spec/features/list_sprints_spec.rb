require 'rails_helper'

RSpec.feature 'Listing sprints', type: :feature do

  before do
    user = create_person
    @project = create_project(user)
    3.times { create_sprint(@project) }
    login_as(user)
  end

  it "lists all project sprint" do
    visit "/projects/#{@project.id}/sprints"
    fail if @project.sprints.empty?
    @project.sprints.each do |sprint|
      expect(page).to have_content sprint.name
    end
  end
end
