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

  describe '#created' do
    let(:notification) { TaskBoardNotification.new(task, person) }

    it 'should prepare message for publishing' do
      notification.created
      expect(JSON.parse(notification.payload)).to eq({'performed_by' => person.name, 'refresh' => true})
    end
  end

  describe '#publish' do
    let(:notification) { TaskBoardNotification.new(task, person) }

    it 'should publish the message' do
      redis_key = "pubsub." + Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{notification.task.user_story.sprint_id}")
      json = {'performed_by' => person.name, 'refresh' => true}.to_json
      expect(REDIS).to receive(:publish).with(redis_key, json)
      notification.created.publish
    end
  end
end
