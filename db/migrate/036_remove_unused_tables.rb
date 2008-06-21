class RemoveUnusedTables < ActiveRecord::Migration
  def self.up
    drop_table :projects
    drop_table :project_members
    drop_table :acceptance_criterium_versions
    drop_table :sprint_element_versions
    drop_table :task_versions
    drop_table :user_story_versions
  end

  def self.down
    # We don't want them back!
  end
end
