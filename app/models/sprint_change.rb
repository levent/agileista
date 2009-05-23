class SprintChange < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :sprint
  belongs_to :person
  
  validates_presence_of :sprint_id
end
