require 'spec_helper'

describe AcceptanceCriterium do
  it {should belong_to(:user_story)}
  it {should validate_presence_of(:detail)}

  it "should touch the story when changes are made" do
    ac = AcceptanceCriterium.make(:user_story => UserStory.make)
    lambda {ac.update_attribute(:detail, "should pass")}.should change(ac.user_story, :updated_at)
  end

  it "should order them per story" do
    us = UserStory.make!(:project => Project.make!)
    ac = AcceptanceCriterium.make!(:user_story => us)
    ac2 = AcceptanceCriterium.make!(:user_story => us)

    ac.user_story.acceptance_criteria.should == [ac, ac2]
    ac.position.should be < ac2.position
  end
end

