class AddUserStoryToSprint < ActiveRecord::Migration
  def self.up
    # remove_column :user_stories, :sprint_id
  end

  def self.down
    # add_column :user_stories, :sprint_id, :integer
  end
end
