class IndexTaskBoardQueries < ActiveRecord::Migration
  def up
    add_index :sprints, [:id, :project_id, :start_at], :order => {:start_at => :desc}
    add_index :sprint_elements, [:sprint_id, :position], :order => {:position=> :asc}
    add_index :task_developers, [:task_id]
  end

  def down
    remove_index :sprints, [:id, :project_id, :start_at]
    remove_index :sprint_elements, [:sprint_id, :position]
    remove_index :task_developers, [:task_id]
  end
end
