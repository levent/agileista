class AddIndexes < ActiveRecord::Migration
  def up
    add_index :tasks, :user_story_id
    add_index :sprint_elements, [:user_story_id, :sprint_id]
  end

  def down
    remove_index :tasks, :user_story_id
    remove_index :sprint_elements, [:user_story_id, :sprint_id]
  end
end
