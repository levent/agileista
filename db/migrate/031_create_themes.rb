class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
      t.column :name, :string, :null => false
      t.column :account_id, :integer
    end
    add_index :themes, [:name, :account_id], :unique => true
  end

  def self.down
    drop_table :themes
  end
end
