class AddAccountIdToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :account_id, :integer
    add_index :releases, [:name, :account_id], :unique => true
  end

  def self.down
    remove_column :releases, :account_id
    remove_index :releases, [:name, :account_id]
  end
end
