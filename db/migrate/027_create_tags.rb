class CreateTags < ActiveRecord::Migration
  def self.up
      create_table :tags do |t|
        t.column :name, :string, :null => false
      end
      add_index :tags, :name, :unique => true

      create_table :taggings do |t|
        t.column :tag_id, :integer, :null => false
        t.column :taggable_id, :integer, :null => false
        t.column :taggable_type, :string, :null => false
      end
      add_index :taggings, [:tag_id, :taggable_id, :taggable_type], :unique => true
    end

    def self.down
      drop_table :tags
      drop_table :taggings
    end
end
