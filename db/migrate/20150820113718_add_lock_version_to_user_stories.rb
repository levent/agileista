class AddLockVersionToUserStories < ActiveRecord::Migration
  def change
    add_column :user_stories, :lock_version, :integer, default: 0
  end
end
