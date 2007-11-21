class AddSprintGoal < ActiveRecord::Migration
  def self.up
    add_column :sprints, :goal, :text
    # add_column :user_stories, :account_id, :integer
  end

  def self.down
    remove_column :sprints, :goal
    # remove_column :user_stories, :account_id
  end
end
