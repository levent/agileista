class MoreIndexes < ActiveRecord::Migration
  def up
    add_index :user_stories, :project_id
    add_index :user_stories, [:project_id, :sprint_id]
    add_index :team_members, :project_id
    add_index :team_members, [:project_id, :person_id]
  end

  def down
    remove_index :user_stories, :project_id
    remove_index :user_stories, [:project_id, :sprint_id]
    remove_index :team_members, :project_id
    remove_index :team_members, [:project_id, :person_id]
  end
end
