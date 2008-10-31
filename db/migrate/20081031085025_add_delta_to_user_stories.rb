class AddDeltaToUserStories < ActiveRecord::Migration
  def self.up
    add_column :user_stories, :delta, :boolean, :default => false
  end

  def self.down
    remove_column :user_stories, :delta
  end
end
