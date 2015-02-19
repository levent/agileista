require 'rails_helper'

RSpec.describe TaskBoard, type: :model do
  let(:user_story) { create_user_story }
  let(:sprint) { create_sprint(user_story.project) }

  before do
    sprint.user_stories << user_story
  end

  describe 'new' do
    let(:task_board) { TaskBoard.new(sprint) }

    it 'should setup the user story' do
      expect(task_board.items.first.user_story).to eq(user_story)
    end
  end
end
