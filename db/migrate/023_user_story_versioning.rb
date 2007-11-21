class UserStoryVersioning < ActiveRecord::Migration
  def self.up
    UserStory.create_versioned_table
    AcceptanceCriterium.create_versioned_table
  end

  def self.down
    UserStory.drop_versioned_table
    AcceptanceCriterium.drop_versioned_table
  end
end
