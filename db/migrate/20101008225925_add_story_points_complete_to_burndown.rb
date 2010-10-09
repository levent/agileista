class AddStoryPointsCompleteToBurndown < ActiveRecord::Migration
  def self.up
    add_column :burndowns, :story_points_complete, :integer
    add_column :burndowns, :story_points_remaining, :integer
  end

  def self.down
    remove_column :burndowns, :story_points_complete
    remove_column :burndowns, :story_points_remaining
  end
end
