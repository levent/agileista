class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :iteration_length
      t.integer :velocity

      t.timestamps
    end

    add_index :projects, :name, :unique => true

    add_column :user_stories, :project_id, :integer
    add_column :sprints, :project_id, :integer
  end
end
