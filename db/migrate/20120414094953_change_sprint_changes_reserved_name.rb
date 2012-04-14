class ChangeSprintChangesReservedName < ActiveRecord::Migration
  def up
    rename_column :sprint_changes, :changes, :changes_description
  end

  def down
    rename_column :sprint_changes, :changes_description, :changes
  end
end
