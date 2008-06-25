class CreateImpediments < ActiveRecord::Migration
  def self.up
    create_table :impediments do |t|
      t.text :description
      t.integer :account_id
      t.integer :person_id
      t.datetime :resolved_at
      t.timestamps
    end
  end

  def self.down
    drop_table :impediments
  end
end
