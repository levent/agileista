class CreateVelocity < ActiveRecord::Migration
  def self.up
    add_column :sprints, :velocity, :integer, :default => nil
    add_column :accounts, :velocity, :integer, :default => nil
  end

  def self.down
    remove_column :sprints, :velocity
    remove_column :accounts, :velocity
  end
end
