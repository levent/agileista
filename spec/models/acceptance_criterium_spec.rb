require 'rails_helper'

RSpec.describe AcceptanceCriterium, type: :model do
  it {should belong_to(:user_story)}
  it {should validate_presence_of(:detail)}

  it "should touch the story when changes are made" do
    ac = create_acceptance_criterion
    expect {ac.update_attribute(:detail, "should pass")}.to change(ac.user_story, :updated_at)
  end

  it "should order them per story" do
    us = create_user_story
    ac = create_acceptance_criterion(us)
    ac2 = create_acceptance_criterion(us)
    us.reload

    expect(ac.user_story.acceptance_criteria).to eq [ac, ac2]
  end
end

