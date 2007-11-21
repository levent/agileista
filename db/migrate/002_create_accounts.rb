class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column :name, :string
      t.column :time_zone, :string
      t.column :account_holder_id, :integer
    end
  end

  def self.down
    drop_table :accounts
  end
end
