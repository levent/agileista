require 'rails_helper'

RSpec.feature 'Create invitations', type: :feature do

  before do
    user = create_person
    @project = create_project
    @project.people << user
    @project.scrum_master = user
    @project.save!
    @project.reload
    login_as(user, scope: :person)
  end

  it "should allow me to navigate to invite people" do
    visit "/projects/#{@project.id}/people"
    click_link "Invite someone to the project"
    expect(page).to have_content 'Invite someone to join'
  end

  it "creates an invitation" do
    visit "/projects/#{@project.id}/invitations/new"
    fill_in 'Email', :with => 'lebreeze@example.com'
    click_button 'Send invite'
    expect(page).to have_content 'Invite sent to lebreeze@example.com'
  end

  it "fails to create an invitation" do
    visit "/projects/#{@project.id}/invitations/new"
    click_button 'Send invite'
    expect(page).to have_content 'Invalid email address'
  end

  context 'with existing user' do
    before do
      @other_user = create_person
      create_project(@other_user)
    end

    it 'adds them to new project' do
      visit "/projects/#{@project.id}/invitations/new"
      fill_in 'Email', :with => @other_user.email
      click_button 'Send invite'
      expect(page).to have_content "#{@other_user.email}"
    end
  end

  context 'with existing invite' do
    before do
      Invitation.create!(email: 'newguy@example.com', project: @project)
    end

    it 'should allow deleting the invite' do
      visit "/projects/#{@project.id}/people"
      click_link "Remove invitation"
      expect(Invitation.where(email: 'newguy@example.com')).to be_empty
    end
  end
end
