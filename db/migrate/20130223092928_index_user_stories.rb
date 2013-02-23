class IndexUserStories < ActiveRecord::Migration
  def change
    add_index :user_stories, [:project_id, :done, :sprint_id]
    add_index :sprints, :project_id
    add_index :sprints, [:project_id, :start_at], :order => {:start_at => :desc}
  end
end
