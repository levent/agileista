class CreateBurndowns < ActiveRecord::Migration
  def self.up
    create_table :burndowns do |t|
      t.column :sprint_id, :integer
      t.column :hours_left, :integer
      t.column :created_on, :date
    end
    add_index :burndowns, [:sprint_id, :created_on]
    add_index :burndowns, :sprint_id
  end

  def self.down
    remove_index :burndowns, :sprint_id
    remove_index :burndowns, [:sprint_id, :created_on]
    drop_table :burndowns
  end
end
