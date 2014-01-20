require 'spec_helper'

describe Invitation do
  it "should downcase email address on create" do
    project = Project.make!
    invite = project.invitations.new(:email => 'LEbREEZE@GMAIL.COM')
    invite.save!
    invite.reload
    invite.email.should == 'lebreeze@gmail.com'
  end
end

