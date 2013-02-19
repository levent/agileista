class AddDeletedAt < ActiveRecord::Migration
  def up
    add_column :people, :deleted_at, :datetime
    add_column :projects, :deleted_at, :datetime
    add_column :team_members, :deleted_at, :datetime
  end

  def down
    remove_column :people, :deleted_at
    remove_column :projects, :deleted_at
    remove_column :team_members, :deleted_at
  end
end
