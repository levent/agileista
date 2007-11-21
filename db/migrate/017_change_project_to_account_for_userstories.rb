class ChangeProjectToAccountForUserstories < ActiveRecord::Migration
  def self.up
    remove_column :user_stories, :project_id
    add_column :user_stories, :account_id, :integer
  end

  def self.down
    remove_column :user_stories, :account_id
    add_column :user_stories, :project_id, :integer
  end
end
