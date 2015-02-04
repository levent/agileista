class Burndown < ActiveRecord::Base
  belongs_to :sprint
  validates_presence_of :sprint_id

#  attr_accessible :sprint_id, :created_on

  default_scope -> {order("created_on")}
end
