class DefaultHoursOnTasks < ActiveRecord::Migration
  def up
    change_column :tasks, :hours, :integer, :default => 1
  end

  def down
    change_column :tasks, :hours, :integer, :default => nil
  end
end
