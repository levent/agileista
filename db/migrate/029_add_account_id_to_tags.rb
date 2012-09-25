class AddAccountIdToTags < ActiveRecord::Migration
  def self.up
    remove_index :tags, :name
    add_column :tags, :account_id, :integer
    add_index :tags, [:name, :account_id], :unique => true
  end

  def self.down
    remove_index :tags, [:name, :account_id]
    remove_column :tags, :account_id
    add_index :tags, :name, :unique => true
  end
end
