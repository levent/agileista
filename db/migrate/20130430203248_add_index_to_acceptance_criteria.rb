class AddIndexToAcceptanceCriteria < ActiveRecord::Migration
  def up
    remove_index :acceptance_criteria, [:user_story_id]
    add_index :acceptance_criteria, [:user_story_id, :position], :order => {:position => :asc}
  end

  def down
    remove_index :acceptance_criteria, [:user_story_id, :position]
    add_index :acceptance_criteria, [:user_story_id]
  end
end
