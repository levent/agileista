require 'spec_helper'

describe "viewing a sprint" do

  before do
    user = login_a_user
    @project = create_project_for(user)
    @sprint = create_sprint_for(@project)
  end

  it "viewing a sprint" do
    visit "/projects/#{@project.id}/sprints/#{@sprint.id}"
    page.should have_content @sprint.name
  end
end
