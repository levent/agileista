require 'rails_helper'

class InvitationManager
  include Invitations::Management

  attr_accessor :email

  def initialize(attributes)
    @email = attributes[:email]
  end
end

RSpec.describe InvitationManager, type: :model do
  before do
    @project = create_project
    @person = create_person
  end

  describe "#add_person_to_project" do
    it "should create a team member and return true if existing person found" do
      expect(InvitationManager.new(email: @person.email).add_person_to_project(@project)).to be_truthy
    end

    it "should return false if no existing person" do
      expect(InvitationManager.new(:email => "levent@example.com").add_person_to_project(@project)).to be_falsey
    end
  end
end

