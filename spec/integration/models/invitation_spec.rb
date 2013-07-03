require 'spec_helper'

describe Invitation do
  it "should downcase email address on create" do
    invite = Invitation.new(:email => 'LEbREEZE@GMAIL.COM', :project => Project.make!)
    invite.save!
    invite.reload
    invite.email.should == 'lebreeze@gmail.com'
  end
end

