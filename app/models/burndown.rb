class Burndown < ActiveRecord::Base
  belongs_to :sprint
  validates :sprint_id, presence: true

  default_scope { order("created_on") }
end
