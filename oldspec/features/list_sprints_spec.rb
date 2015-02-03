require 'spec_helper'

describe "listing all sprints" do

  before do
    user = login_a_user
    @project = create_project_for(user)
    3.times { create_sprint_for(@project) }
  end

  it "lists all project sprint" do
    visit "/projects/#{@project.id}/sprints"
    fail if @project.sprints.empty?
    @project.sprints.each do |sprint|
      page.should have_content sprint.name
    end
  end
end
