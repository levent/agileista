class CreateSprintElements < ActiveRecord::Migration
  def self.up
    create_table :sprint_elements do |t|
      t.column :sprint_id, :integer
      t.column :user_story_id, :integer
      t.column :position, :integer
    end
  end

  def self.down
    drop_table :sprint_elements
  end
end
