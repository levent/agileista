class SprintElementsVersioning < ActiveRecord::Migration
  def self.up
    SprintElement.create_versioned_table
  end

  def self.down
    SprintElement.drop_versioned_table
  end
end
