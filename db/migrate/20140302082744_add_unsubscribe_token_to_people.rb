class AddUnsubscribeTokenToPeople < ActiveRecord::Migration
  def change
    add_column :people, :unsubscribe_token, :string
    add_index :people, :unsubscribe_token
  end
end
