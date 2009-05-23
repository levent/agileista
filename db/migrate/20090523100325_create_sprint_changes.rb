class CreateSprintChanges < ActiveRecord::Migration
  def self.up
    create_table :sprint_changes do |t|
      t.integer :auditable_id
      t.integer :sprint_id
      t.integer :person_id
      t.text :auditable_type
      t.string :kind
      t.text :changes
      t.boolean :major
      t.text :details
      
      t.timestamps
    end
  end

  def self.down
    drop_table :sprint_changes
  end
end
