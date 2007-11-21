class CreateUserStories < ActiveRecord::Migration
  def self.up
    create_table :user_stories do |t|
      t.column :definition, :string
      t.column :description, :text
      t.column :project_id, :integer
      # t.column :responsible_id, :integer
      t.column :story_points, :integer
      t.column :position, :integer
      t.column :done, :integer, :limit => 2, :default => 0, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :user_stories
  end
end
