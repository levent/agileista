class ChangeTaskDescriptionFieldLength < ActiveRecord::Migration
  def self.up
    change_column :tasks, :description, :text
  end

  def self.down
  end
end
