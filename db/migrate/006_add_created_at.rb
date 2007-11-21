class AddCreatedAt < ActiveRecord::Migration
  def self.up
    add_column :people, :created_at, :datetime
    add_column :people, :updated_at, :datetime
    add_column :accounts, :created_at, :datetime
    add_column :accounts, :updated_at, :datetime
    add_column :projects, :created_at, :datetime
    add_column :projects, :updated_at, :datetime
  end

  def self.down
    remove_column :people, :created_at
    remove_column :people, :updated_at
    remove_column :accounts, :created_at
    remove_column :accounts, :updated_at
    remove_column :projects, :created_at
    remove_column :projects, :updated_at
  end
end
