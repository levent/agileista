class CreateHipchats < ActiveRecord::Migration
  def up
    create_table :hip_chat_integrations do |t|
      t.string :room
      t.string :token
      t.boolean :notify, :default => false
      t.integer :project_id
    end
  end

  def down
    drop_table :hip_chat_integrations
  end
end
