class DropDoneFromUserStories < ActiveRecord::Migration
  def up
    remove_column :user_stories, :done
  end

  def down
    add_column :user_stories, :done, :integer, :default => 0, :null => false
  end
end
