class DropTags < ActiveRecord::Migration
  def up
    drop_table :tags
    drop_table :taggings
  end

  def down
    create_table "taggings", :force => true do |t|
      t.integer  "tag_id",        :default => 0,  :null => false
      t.integer  "taggable_id",   :default => 0,  :null => false
      t.string   "taggable_type", :default => "", :null => false
      t.integer  "tagger_id"
      t.string   "tagger_type"
      t.string   "context"
      t.datetime "created_at"
    end

    add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", :unique => true
    add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
    add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

    create_table "tags", :force => true do |t|
      t.string  "name",       :default => "", :null => false
      t.integer "account_id"
    end

    add_index "tags", ["name", "account_id"], :name => "index_tags_on_name_and_account_id", :unique => true
  end
end
