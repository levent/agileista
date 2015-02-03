require 'spec_helper'

describe "creating an invitation" do

  before do
    user = login_a_user
    @project = create_project_for(user, false)
  end

  it "should allow me to navigate to invite people" do
    visit "/projects/#{@project.id}/people"
    click_link "Invite someone to the project"
    page.should have_content 'Invite someone to join'
  end

  it "creates an invitation" do
    visit "/projects/#{@project.id}/invitations/new"
    fill_in 'Email', :with => 'lebreeze@example.com'
    click_button 'Send invite'
    page.should have_content 'Invite sent to lebreeze@example.com'
  end

  it "fails to create an invitation" do
    visit "/projects/#{@project.id}/invitations/new"
    click_button 'Send invite'
    page.should have_content 'Invalid email address'
  end
end
