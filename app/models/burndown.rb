class Burndown < ActiveRecord::Base
  
  belongs_to :sprint
  validates_presence_of :hours_left
  
end
