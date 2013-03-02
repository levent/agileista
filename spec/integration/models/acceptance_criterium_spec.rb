require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AcceptanceCriterium do
  it {should belong_to(:user_story)}
  it {should validate_presence_of(:detail)}

  it "should touch the story when changes are made" do
    ac = AcceptanceCriterium.make(:user_story => UserStory.make)
    lambda {ac.update_attribute(:detail, "should pass")}.should change(ac.user_story, :updated_at)
  end
end

