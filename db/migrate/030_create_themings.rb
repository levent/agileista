class CreateThemings < ActiveRecord::Migration
  def self.up
    create_table :themings do |t|
      t.column :theme_id, :integer, :null => false
      t.column :themable_id, :integer, :null => false
      t.column :themable_type, :string, :null => false
    end
    add_index :themings, [:theme_id, :themable_id, :themable_type], :unique => true
  end

  def self.down
    drop_table :themings
  end
end
