require 'rails_helper'

RSpec.describe ChatMessage, type: :model do

  let(:host) { 'https://test.host' }
  let(:person) { create_person }
  let(:project) { create_project(person) }
  let(:sprint) { create_sprint(project) }
  let(:task) { create_task(project) }
  let(:user_story) { task.user_story }

  let(:chat_message) { ChatMessage.new(host, {
                        project: project,
                        sprint: sprint,
                        person: person,
                        user_story: user_story,
                        task: task
                      } ) }

  describe '#new' do
    it 'should set the host' do
      expect(chat_message.host).to eq('https://test.host')
    end

    it 'should set the person' do
      expect(chat_message.person).to eq(person)
    end

    it 'should set the project' do
      expect(chat_message.project).to eq(project)
    end

    it 'should set the sprint' do
      expect(chat_message.sprint).to eq(sprint)
    end

    it 'should set the user_story' do
      expect(chat_message.user_story).to eq(user_story)
    end

    it 'should set the task' do
      expect(chat_message.task).to eq(task)
    end
  end

  describe '#sprint_created' do
    it 'should render anappropriate message' do
      message = "Sprint <a href=\"#{Rails.application.routes.url_helpers.project_sprint_url(project, sprint, host: host)}\">##{sprint.id}</a> <strong>created</strong> by #{person.name}: \"#{sprint.name}\""
      expect(chat_message.sprint_created).to eq(message)
    end
  end

  describe '#sprint_updated' do
    it 'should render anappropriate message' do
      message = "Sprint <a href=\"#{Rails.application.routes.url_helpers.project_sprint_url(project, sprint, host: host)}\">##{sprint.id}</a> <strong>updated</strong> by #{person.name}: \"#{sprint.name}\""
      expect(chat_message.sprint_updated).to eq(message)
    end
  end

  describe '#task_created' do
    it 'should render anappropriate message' do
      message = "Task <strong>created</strong> on <a href=\"#{Rails.application.routes.url_helpers.edit_project_user_story_url(project, user_story, host: host)}\">##{user_story.id}</a> by #{person.name}: \"#{task.definition}\""
      expect(chat_message.task_created).to eq(message)
    end
  end

  describe '#task_renounced' do
    it 'should render anappropriate message' do
      message = "Task <strong>renounced</strong> on <a href=\"#{Rails.application.routes.url_helpers.edit_project_user_story_url(project, user_story, host: host)}\">##{user_story.id}</a> by #{person.name}: \"#{task.definition}\""
      expect(chat_message.task_renounced).to eq(message)
    end
  end

  describe '#task_claimed' do
    it 'should render anappropriate message' do
      message = "Task <strong>claimed</strong> on <a href=\"#{Rails.application.routes.url_helpers.edit_project_user_story_url(project, user_story, host: host)}\">##{user_story.id}</a> by #{person.name}: \"#{task.definition}\""
      expect(chat_message.task_claimed).to eq(message)
    end
  end

  describe '#task_completed' do
    it 'should render anappropriate message' do
      message = "Task <strong>completed</strong> on <a href=\"#{Rails.application.routes.url_helpers.edit_project_user_story_url(project, user_story, host: host)}\">##{user_story.id}</a> by #{person.name}: \"#{task.definition}\""
      expect(chat_message.task_completed).to eq(message)
    end
  end
end
