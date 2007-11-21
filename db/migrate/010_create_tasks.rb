class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :definition, :string
      t.column :description, :string
      t.column :hours, :integer
      t.column :position, :integer
      t.column :developer_id, :integer
      t.column :user_story_id, :integer
    end
  end

  def self.down
    drop_table :tasks
  end
end
