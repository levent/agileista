require 'rails_helper'

RSpec.describe HipChatIntegration, type: :model do
  it {should belong_to(:project)}
  it {should validate_presence_of(:project_id)}

  let (:hipchat) { HipChatIntegration.new }

  describe '#required_fields_present?' do
    it 'should be true if room and token' do
      hipchat.room = 'agileista'
      hipchat.token = 'token'
      expect(hipchat.required_fields_present?).to be_truthy
    end
    it 'should be false by default' do
      expect(hipchat.required_fields_present?).to be_falsey
    end
  end
end
