class AddPositionToThemes < ActiveRecord::Migration
  def self.up
    add_column :themes, :position, :integer
  end

  def self.down
    remove_column :themes, :position
  end
end
