require 'protected_attributes'
require 'unit_helper'
require 'invitation'

class InvitationManager
  include Invitations::Management

  attr_accessor :email

  def initialize(attributes)
    @email = attributes[:email]
  end
end

describe InvitationManager do
  before do
    @project = fire_double("Project")
    @team_member_class = fire_replaced_class_double("TeamMember")
    @person_class = fire_replaced_class_double("Person")
    @invitation_class = fire_replaced_class_double("Invitation")
    @notification_class = fire_replaced_class_double("NotificationMailer")
    @person = fire_double("Person")
    @invitation = fire_double("Invitation")
    @notification = fire_double("NotificationMailer")
  end

  describe "#add_person_to_project" do
    it "should create a team member and return true if existing person found" do
      @person.should_receive(:id).and_return(187)
      @project.should_receive(:id).and_return(78)
      @person_class.should_receive(:where).with({:email=>"lebreeze@example.com"}).and_return([@person])
      @team_member_class.should_receive(:find_or_create_by).with(project_id: 78, person_id: 187)

      InvitationManager.new(:email => "lebreeze@example.com").add_person_to_project(@project).should be_true
    end

    it "should return false if no existing person" do
      @person_class.should_receive(:where).with({:email=>"levent@example.com"}).and_return([])
      InvitationManager.new(:email => "levent@example.com").add_person_to_project(@project).should be_false
    end
  end

  describe "#create_and_notify_for_project" do
    it "should create an invite and invite new person" do
      @invitation.should_receive(:valid?).and_return(true)
      @invitation_class.should_receive(:first_or_create).and_return(@invitation)
      @invitation_class.should_receive(:where).with(:email => "levent@example.com").and_return(@invitation_class)
      @notification_class.should_receive(:invite_to_project).with(@project, @invitation).and_return(@notification)
      @notification.should_receive(:deliver)
      @project.should_receive(:invitations).and_return(@invitation_class)

      InvitationManager.new(:email => "levent@example.com").create_and_notify_for_project(@project)
    end

    it "should return false if invalid email" do
      @invitation.should_receive(:valid?).and_return(false)
      @invitation_class.should_receive(:first_or_create).and_return(@invitation)
      @invitation_class.should_receive(:where).with(:email => "").and_return(@invitation_class)
      @project.should_receive(:invitations).and_return(@invitation_class)

      InvitationManager.new(:email => "").create_and_notify_for_project(@project).should be_false
    end
  end
end
