require 'rails_helper'

RSpec.describe UserStoriesHelper, :type => :helper do

  describe "#parse_definition" do

    let(:user_story) { create_user_story }

    it "should return the definition if no tags" do
      expect(helper.parse_definition(user_story.definition, nil)).to eq user_story.definition
    end

    it "should convert tags to search links" do
      project = create_project
      expect(helper.parse_definition("[bug] Fix universe", project)).to eq "<a class=\"tagged\" href=\"/projects/#{project.id}/search?q=tag%3Abug\">[bug]</a> Fix universe"
    end
  end
end
