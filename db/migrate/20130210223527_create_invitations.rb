class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.integer :project_id
      t.integer :sent_count, :default => 0

      t.timestamps null: false
    end

    add_index :invitations, [:email, :project_id], :unique => true
  end
end
