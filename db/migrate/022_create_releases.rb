class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.column :name, :string
      t.column :end_date, :datetime
    end
    add_column :user_stories, :release_id, :integer
  end

  def self.down
    drop_table :releases
    remove_column :user_stories, :release_id
  end
end
