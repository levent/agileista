require 'spec_helper'

describe "listing my projects" do

  before do
    user = login_a_user
    @project = create_project_for(user)
  end

  it "listing when only one project" do
    visit '/projects'
    page.should have_content @project.name.humanize
    current_path.should == '/projects'
  end
end
