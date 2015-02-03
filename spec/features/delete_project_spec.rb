require 'spec_helper'

describe "deleting a project" do

  before do
    user = login_a_user
    @project = create_project_for(user)
  end

  it "deletes a project" do
    visit "/projects/#{@project.id}/edit"
    click_link 'Delete project'
    page.should have_content 'Project removed'
  end
end
