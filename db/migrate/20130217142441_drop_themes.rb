class DropThemes < ActiveRecord::Migration
  def up
    drop_table :themes
    drop_table :themings
  end

  def down
    create_table "themes", :force => true do |t|
      t.string  "name",        :default => "", :null => false
      t.integer "account_id"
      t.text    "description"
      t.integer "position"
    end

    add_index "themes", ["name", "account_id"], :name => "index_themes_on_name_and_account_id", :unique => true

    create_table "themings", :force => true do |t|
      t.integer "theme_id",      :default => 0,  :null => false
      t.integer "themable_id",   :default => 0,  :null => false
      t.string  "themable_type", :default => "", :null => false
    end

    add_index "themings", ["theme_id", "themable_id", "themable_type"], :name => "index_themings_on_theme_id_and_themable_id_and_themable_type", :unique => true
  end
end
