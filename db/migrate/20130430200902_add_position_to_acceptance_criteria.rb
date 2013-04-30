class AddPositionToAcceptanceCriteria < ActiveRecord::Migration
  def change
    add_column :acceptance_criteria, :position, :integer
  end
end
