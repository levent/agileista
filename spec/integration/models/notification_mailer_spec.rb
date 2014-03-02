require 'spec_helper'

describe NotificationMailer do
  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.deliveries = []
  end

  describe "#invite_to_project" do
    before do
      @invitation = Invitation.make
    end

    it "should invite a user to a project" do
      NotificationMailer.invite_to_project(@invitation.project, @invitation).deliver
      email = ActionMailer::Base.deliveries.first
      email.to.should == [@invitation.email]
      email.from.should == ['notifications@agileista.local']
      email.subject.should == "[#{@invitation.project.name}] You have been invited to join this project"
      email.body.should =~ /You have been invited to join the project '#{@invitation.project.name.humanize}' on Agileista./
    end
  end
end
