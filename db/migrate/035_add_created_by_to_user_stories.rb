class AddCreatedByToUserStories < ActiveRecord::Migration
  def self.up
    add_column :user_stories, :person_id, :integer, :default => nil
  end

  def self.down
    remove_column :user_stories, :person_id
  end
end
