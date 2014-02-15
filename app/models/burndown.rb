class Burndown < ActiveRecord::Base
  belongs_to :sprint
  validates_presence_of :sprint_id

  default_scope -> {order("created_on")}
end
