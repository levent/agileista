class RemovePasswordFromPeople < ActiveRecord::Migration
  def self.up
    remove_column :people, :password
  end

  def self.down
  end
end
