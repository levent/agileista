class ChangeProjectColumnsToString < ActiveRecord::Migration
  def self.up
    change_column :projects, :iteration_length, :string
    change_column :projects, :work_hours, :string
  end

  def self.down
    change_column :projects, :iteration_length, :integer
    change_column :projects, :work_hours, :integer
  end
end
