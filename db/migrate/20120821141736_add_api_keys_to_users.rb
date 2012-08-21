class AddApiKeysToUsers < ActiveRecord::Migration
  def change
    add_column :people, :api_key, :string, :default => nil
    add_index :people, [:account_id, :api_key, :authenticated, :activation_code], :name => 'by_api_key'
  end
end
