class CreateAcceptanceCriteria < ActiveRecord::Migration
  def self.up
    create_table :acceptance_criteria do |t|
      t.column :detail, :string
      t.column :user_story_id, :integer
    end
  end

  def self.down
    drop_table :acceptance_criteria
  end
end
