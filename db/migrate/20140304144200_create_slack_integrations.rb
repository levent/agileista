class CreateSlackIntegrations < ActiveRecord::Migration
  def change
    create_table :slack_integrations do |t|
      t.string :team
      t.string :channel
      t.string :token
      t.integer :project_id
    end
  end
end
