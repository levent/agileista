class ChangeDefinitionToTextUserStories < ActiveRecord::Migration
  def self.up
    change_column :user_stories, :definition, :text
  end

  def self.down
    change_column :user_stories, :definition, :string
  end
end
