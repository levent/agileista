class DropAccounts < ActiveRecord::Migration
  def change
    drop_table :accounts
    remove_column :user_stories, :account_id
    remove_column :people, :account_id
    remove_column :sprints, :account_id
  end
end
