class CreateTaskDevelopers < ActiveRecord::Migration
  def self.up
    create_table :task_developers do |t|
      t.integer :task_id
      t.integer :developer_id
      t.timestamps
    end
  end

  def self.down
    drop_table :task_developers
  end
end
