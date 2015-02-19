require 'rails_helper'

RSpec.describe TaskBoard::Item, type: :model do

  describe "filters" do

    before do
      @task1 = create_task
      @task2 = create_task
      @task3 = create_task
      @task3.team_members = [create_person]
      @task4 = create_task
      @task4.update_attribute(:done, true)

      all_tasks = [@task1, @task2, @task3, @task4]
      user_story = create_user_story
      user_story.tasks << all_tasks
      @item = TaskBoard::Item.new(user_story)
    end

    describe "available_tasks" do
      it "should get all incomplete tasks" do
        tasks = @item.available_tasks
        expect(tasks).to include(@task1)
        expect(tasks).to include(@task2)
        expect(tasks).not_to include(@task3)
        expect(tasks).not_to include(@task4)
      end
    end

    describe "inprogress_tasks" do
      it "should get all inprogress tasks" do
        tasks = @item.inprogress_tasks
        expect(tasks).to include(@task3)
        expect(tasks).not_to include(@task1)
        expect(tasks).not_to include(@task2)
        expect(tasks).not_to include(@task4)
      end
    end

    describe "complete_tasks" do
      it "should get all complete tasks" do
        expect(@item.complete_tasks).to include(@task4)
      end
    end
  end
end

