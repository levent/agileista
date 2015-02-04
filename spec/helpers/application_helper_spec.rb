require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do

  let(:us) { UserStory.new }

  describe "show_story_points" do
    it "should give you an informative message on how many story points a story is worth" do
      expect(helper.show_story_points(13)).to eq "13 story points"
    end

    it "should inform user if story points aren't defind" do
      expect(helper.show_story_points(nil)).to eq"? story points"
    end
  end

  describe "#show_stakeholder" do
    # deals with legacy before created_by
    it "should return by Unknown if no stakeholder or creator" do
      expect(helper.show_stakeholder(us)).to eq "Unknown"
    end

    it "should return by Creator if no stakeholder" do
      us.person = Person.new(:name => 'monkey face')
      expect(helper.show_stakeholder(us)).to eq "monkey face"
    end

    it "should return by stakeholder if provided" do
      us.stakeholder = "fred dude"
      expect(helper.show_stakeholder(us)).to eq "fred dude"
    end

    it "should return by stakeholder if provided even if creator also there" do
      us.person = Person.new(:name => 'monkey face')
      us.stakeholder = "fred dude"
      expect(helper.show_stakeholder(us)).to eq "fred dude"
    end

    it "should have a user override option" do
      person = Person.new(:name => 'monkey face')
      expect(helper.show_stakeholder(us, person)).to eq "monkey face"
    end
  end
end
