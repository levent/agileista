require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it "should downcase email address on create" do
    project = create_project
    invite = project.invitations.new(:email => 'LEbREEZE@GMAIL.COM')
    invite.save!
    invite.reload
    expect(invite.email).to eq 'lebreeze@gmail.com'
  end
end

