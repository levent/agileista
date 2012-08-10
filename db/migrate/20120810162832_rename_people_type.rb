class RenamePeopleType < ActiveRecord::Migration
  def up
    rename_column :people, :type, :old_type
  end

  def down
    rename_column :people, :old_type, :type
  end
end
