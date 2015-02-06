class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.integer :person_id
      t.integer :project_id
      t.boolean :scrum_master, :default => false

      t.timestamps null: false
    end
  end
end
