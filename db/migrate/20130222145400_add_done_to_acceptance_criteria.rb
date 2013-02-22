class AddDoneToAcceptanceCriteria < ActiveRecord::Migration
  def change
    add_column :acceptance_criteria, :done, :boolean, :default => false
    add_index :acceptance_criteria, :user_story_id
  end
end
