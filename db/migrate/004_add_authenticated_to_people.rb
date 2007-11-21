class AddAuthenticatedToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :authenticated, :integer, :limit => 2, :default => 0
  end

  def self.down
    remove_column :people, :authenticated
  end
end
