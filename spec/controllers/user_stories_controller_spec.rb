require 'rails_helper'

RSpec.describe UserStoriesController, type: :controller do
  describe "POST plan" do
    let(:person) { create_person }
    let(:project) { create_project(person) }
    let(:sprint) { create_sprint(project) }
    let(:user_story) { create_user_story(project) }

    before do
      sign_in(person)
    end

    it "adds the story to the sprint" do
      post :plan, id: user_story.id, sprint_id: sprint.id, project_id: project.id
      user_story.reload
      expect(user_story.sprint).to eq(sprint)
      expect(SprintElement.where(sprint_id: sprint.id, user_story_id: user_story.id).count).to eq(1)
    end
  end

  describe "POST unplan" do
    let(:person) { create_person }
    let(:project) { create_project(person) }
    let(:sprint) { create_sprint(project) }
    let(:user_story) { create_user_story(project) }

    before do
      assign_user_story_to_sprint(user_story, sprint)
      sign_in(person)
    end

    it "removes the story from the sprint" do
      post :unplan, id: user_story.id, sprint_id: sprint.id, project_id: project.id
      user_story.reload
      expect(user_story.sprint).to be_nil
      expect(SprintElement.where(sprint_id: sprint.id, user_story_id: user_story.id)).to be_empty
    end
  end
end
