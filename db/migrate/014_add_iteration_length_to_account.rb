class AddIterationLengthToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :iteration_length, :integer
    add_column :sprints, :name, :string
  end

  def self.down
    remove_column :accounts, :iteration_length
    remove_column :sprints, :name
  end
end
