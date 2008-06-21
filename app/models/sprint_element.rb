class SprintElement < ActiveRecord::Base
  acts_as_list :scope => :sprint
  
  belongs_to :sprint
  belongs_to :user_story  
end