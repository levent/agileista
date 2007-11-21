class RemoveTypeFromPeople < ActiveRecord::Migration
  def self.up
    remove_column :people, :type
  end

  def self.down
    add_column :people, :type, :string, :null => true
  end
end
