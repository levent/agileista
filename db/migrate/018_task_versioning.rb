class TaskVersioning < ActiveRecord::Migration
  def self.up
    Task.create_versioned_table
  end

  def self.down
    Task.drop_versioned_table
  end
end
