class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :type, :string
      t.column :name, :string
      t.column :email, :string
      t.column :account_id, :integer
      t.column :password, :string
    end
  end

  def self.down
    drop_table :people
  end
end
