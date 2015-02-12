require 'rails_helper'

RSpec.describe Project, :type => :model do
  let(:project) { create_project }
  describe '#use_estimates' do
    it 'should default to true' do
      expect(project.use_estimates?).to be_truthy
    end
  end
end
