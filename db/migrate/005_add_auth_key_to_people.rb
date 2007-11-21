class AddAuthKeyToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :activation_code, :string, :null => true
  end

  def self.down
    remove_column :people, :activation_code
  end
end
