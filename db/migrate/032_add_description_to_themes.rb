class AddDescriptionToThemes < ActiveRecord::Migration
  def self.up
    add_column :themes, :description, :text
  end

  def self.down
    remove_column :themes, :description
  end
end
