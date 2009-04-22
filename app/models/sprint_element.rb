class SprintElement < ActiveRecord::Base
  acts_as_list :scope => :sprint
  
  belongs_to :sprint
  belongs_to :user_story
  
  after_save :calculate_burndown
  after_destroy :calculate_burndown
  
  def calculate_burndown
    if self.sprint
      self.sprint.reload
      self.sprint.calculate_day_zero
    end
  end
end