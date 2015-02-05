require 'rails_helper'

RSpec.describe TaskBoardNotification, :type => :model do
  let(:task) { create_task }
  let(:person) { create_person }

  describe '#initialize' do
    it 'should require a parameter (task)' do
      expect { TaskBoardNotification.new }.to raise_error(ArgumentError)
    end

    it 'should take a task' do
      expect(TaskBoardNotification.new(task, person).task).to eq(task)
    end

    it 'should take a person' do
      expect(TaskBoardNotification.new(task, person).person).to eq(person)
    end
  end

  context 'with a notification object initialized' do
    let(:notification) { TaskBoardNotification.new(task, person) }

    describe '#refresh' do
      it 'should prepare message for publishing' do
        notification.refresh
        expect(JSON.parse(notification.payload)).to eq({'performed_by' => person.name, 'refresh' => true})
      end
    end

    describe '#renounce' do
      it 'should prepare message for publishing' do
        notification.renounce
        devs = notification.task.assignees.split(',')
        json = { notification: "#{person.name} renounced task of ##{notification.task.user_story.id}", performed_by: person.name, action: 'renounce', task_id: notification.task.id, task_hours: notification.task.hours, task_devs: devs, user_story_status: notification.task.user_story.status, user_story_id: notification.task.user_story_id }.stringify_keys
        expect(JSON.parse(notification.payload)).to eq(json)
      end
    end

    describe '#claim' do
      it 'should prepare message for publishing' do
        notification.claim
        devs = notification.task.assignees.split(',')
        json = { notification: "#{person.name} claimed task of ##{notification.task.user_story_id}", performed_by: person.name, action: 'claim', task_id: notification.task.id, task_hours: notification.task.hours, task_devs: devs, user_story_status: notification.task.user_story.status, user_story_id: notification.task.user_story_id }.stringify_keys
        expect(JSON.parse(notification.payload)).to eq(json)
      end
    end

    describe '#complete' do
      it 'should prepare message for publishing' do
        notification.complete
        devs = notification.task.assignees.split(',')
        json = { notification: "#{person.name} completed task of ##{notification.task.user_story_id}", performed_by: person.name, action: 'complete', task_id: notification.task.id, task_hours: notification.task.hours, task_devs: devs, user_story_status: notification.task.user_story.status, user_story_id: notification.task.user_story_id }.stringify_keys
        expect(JSON.parse(notification.payload)).to eq(json)
      end
    end

    describe '#publish' do
      it 'should publish the message' do
        redis_key = "pubsub." + Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{notification.task.user_story.sprint_id}")
        json = {'performed_by' => person.name, 'refresh' => true}.to_json
        expect(REDIS).to receive(:publish).with(redis_key, json)
        notification.refresh.publish
      end
    end

  end
end
