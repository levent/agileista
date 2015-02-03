require 'rails_helper'

RSpec.describe NotificationMailer, type: :model do
  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.deliveries = []
  end

  describe "#invite_to_project" do
    before do
      project = create_project
      @invitation = project.invitations.create!(email: Faker::Internet.email)
    end

    it "should invite a user to a project" do
      NotificationMailer.invite_to_project(@invitation.project, @invitation).deliver
      email = ActionMailer::Base.deliveries.first
      expect(email.to).to eq [@invitation.email]
      expect(email.from).to eq ['notifications@agileista.local']
      expect(email.subject).to eq "[#{@invitation.project.name}] You have been invited to join this project"
      expect(email.body).to include "You have been invited to join the project '#{@invitation.project.name.humanize}' on Agileista."
    end
  end
end
