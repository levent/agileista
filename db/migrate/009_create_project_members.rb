class CreateProjectMembers < ActiveRecord::Migration
  def self.up
    create_table :project_members do |t|
      t.column :person_id, :integer
      t.column :project_id, :integer
    end
  end

  def self.down
    # drop_table :project_members
  end
end
