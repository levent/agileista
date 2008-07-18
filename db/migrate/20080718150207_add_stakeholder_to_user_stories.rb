class AddStakeholderToUserStories < ActiveRecord::Migration
  def self.up
    add_column :user_stories, :stakeholder, :string, :default => ""
  end

  def self.down
    remove_column :user_stories, :stakeholder
  end
end
