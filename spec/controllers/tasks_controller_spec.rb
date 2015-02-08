require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:person) { create_person }
  let(:project) { create_project(person) }
  let(:sprint) { create_sprint(project) }
  let(:task) { create_task(project) }
  let(:user_story) { task.user_story }
  let(:task_definition) { Faker::Lorem.sentence }

  before do
    sign_in(person)
  end

  describe 'POST create' do
    it 'adds a task to a story' do
      post :create, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, task: { definition: task_definition }, format: :js
      user_story.reload
      expect(user_story.tasks.last.definition).to eq(task_definition)
    end

    it 'notifies other people' do
      expect(controller).to receive(:notify_integrations).with(:task_created)
      post :create, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, task: { definition: task_definition }, format: :js
    end
  end

  describe 'PUT renounce' do
    before do
      task.team_members << person
    end

    it 'removes me from the task' do
      put :renounce, id: task.id, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, format: :js
      task.reload
      expect(task.team_members).to eq([])
    end

    it 'notifies other people' do
      expect(controller).to receive(:notify_integrations).with(:task_renounced)
      put :renounce, id: task.id, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, format: :js
    end
  end

  describe 'PUT claim' do
    it 'assigns me to the task' do
      put :claim, id: task.id, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, format: :js
      task.reload
      expect(task.team_members).to eq([person])
    end

    it 'notifies other people' do
      expect(controller).to receive(:notify_integrations).with(:task_claimed)
      put :claim, id: task.id, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, format: :js
    end
  end

  describe 'PUT complete' do
    it 'marks the task as done' do
      put :complete, id: task.id, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, format: :js
      task.reload
      expect(task.done).to be_truthy
    end

    it 'notifies other people' do
      expect(controller).to receive(:notify_integrations).with(:task_completed)
      put :complete, id: task.id, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, format: :js
    end
  end

  describe 'DELETE destroy' do
    it 'should delete the task' do
      request.env['HTTP_REFERER'] = 'somewhere' # TODO: Remove smell
      delete :destroy, id: task.id, user_story_id: user_story.id, sprint_id: sprint.id, project_id: project.id, format: :js
      expect(Task.where(id: task.id)).to be_empty
    end
  end
end
