class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column :name, :string
      t.column :iteration_length, :integer
      t.column :work_hours, :integer
      t.column :account_id, :integer
    end
  end

  def self.down
    drop_table :projects
  end
end
