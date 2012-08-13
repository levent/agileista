class DropImpediments < ActiveRecord::Migration
  def up
    drop_table :impediments
  end

  def down
    create_table :impediments do |t|
      t.text :description
      t.integer :account_id
      t.integer :person_id
      t.datetime :resolved_at
      t.timestamps
    end
  end
end
