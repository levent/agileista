class AddCannotBeEstimatedToUserStories < ActiveRecord::Migration
  def self.up
    add_column :user_stories, :cannot_be_estimated, :integer, :limit => 1, :default => 0
  end

  def self.down
    remove_column :user_stories, :cannot_be_estimated
  end
end
