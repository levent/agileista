class DropAudits < ActiveRecord::Migration
  def up
    drop_table :sprint_changes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
