require 'rails_helper'

RSpec.describe SlackIntegration, type: :model do
  it {should belong_to(:project)}
  it {should validate_presence_of(:project_id)}

  let (:slack) { SlackIntegration.new }

  describe '#required_fields_present?' do
    it 'should be true if team, token and channel present' do
      slack.team = 'agileista'
      slack.token = 'token'
      slack.channel = 'channel'
      expect(slack.required_fields_present?).to be_truthy
    end
    it 'should be false by default' do
      expect(slack.required_fields_present?).to be_falsey
    end
  end
end
