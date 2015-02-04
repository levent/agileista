require 'rails_helper'

RSpec.describe Burndown, type: :model do
  it {should belong_to(:sprint)}
  it {should validate_presence_of(:sprint_id)}

  context "sort order" do
    it "should be ordered by date by default" do
      sprint = create_sprint
      b1 = sprint.burndowns.create!(created_on: 3.days.ago)
      b4 = sprint.burndowns.create!(created_on: 6.days.ago)
      b2 = sprint.burndowns.create!(created_on: 4.days.ago)
      b3 = sprint.burndowns.create!(created_on: 5.days.ago)
      b5 = sprint.burndowns.create!(created_on: 7.days.ago)
      expect(Burndown.all).to eq [b5, b4, b3, b2, b1]
    end
  end
end

