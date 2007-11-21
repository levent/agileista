class CreateSprints < ActiveRecord::Migration
  def self.up
    create_table :sprints do |t|
      # t.column :name, :stri ng
      # t.column :user_story_id, :integer
      t.column :account_id, :integer
      # t.column :position, :integer
      t.column :start_at, :datetime
      t.column :end_at, :datetime
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_column :user_stories, :sprint_id, :integer
  end

  def self.down
    remove_column :user_stories, :sprint_id
    drop_table :sprints
  end
end
