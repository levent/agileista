require 'rails_helper'

RSpec.describe Burndown, type: :model do
  it {should belong_to(:sprint)}
  it {should validate_presence_of(:sprint_id)}

  let(:sprint) { create_sprint }

  context "sort order" do
    it "should be ordered by date by default" do
      b1 = sprint.burndowns.create!(created_on: 3.days.ago)
      b4 = sprint.burndowns.create!(created_on: 6.days.ago)
      b2 = sprint.burndowns.create!(created_on: 4.days.ago)
      b3 = sprint.burndowns.create!(created_on: 5.days.ago)
      b5 = sprint.burndowns.create!(created_on: 7.days.ago)
      expect(Burndown.all).to eq [b5, b4, b3, b2, b1]
    end
  end

  describe '.generate!' do
    let(:date) { 1.day.ago }

    before do
      allow(sprint).to receive(:hours_left) { 100 }
      allow(sprint).to receive(:story_points_burned) { 1 }
      allow(sprint).to receive(:total_story_points) { 3 }
      Burndown.generate!(sprint, date)
    end

    it 'should take a sprint and date and create a burndown' do
      burndown = Burndown.where(sprint_id: sprint.id, created_on: date)
      expect(burndown).not_to be_empty
    end

    it 'should set the hours_left of the burndown' do
      burndown = Burndown.where(sprint_id: sprint.id, created_on: date).first
      expect(burndown.hours_left).to eq(100)
    end

    it 'should set the story_points_complete of the burndown' do
      burndown = Burndown.where(sprint_id: sprint.id, created_on: date).first
      expect(burndown.story_points_complete).to eq(1)
    end

    it 'should set the story_points_remaining of the burndown' do
      burndown = Burndown.where(sprint_id: sprint.id, created_on: date).first
      expect(burndown.story_points_remaining).to eq(3)
    end
  end
end
