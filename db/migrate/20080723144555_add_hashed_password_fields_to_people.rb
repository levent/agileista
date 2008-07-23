class AddHashedPasswordFieldsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :hashed_password, :string, :limit => 40
    add_column :people, :salt, :string, :limit => 40
  end

  def self.down
    remove_column :people, :hashed_password
    remove_column :people, :salt
  end
end
