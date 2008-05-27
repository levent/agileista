class Task < ActiveRecord::Base
  
  acts_as_list :scope => :user_story
  # acts_as_versioned
  
  validates_presence_of :definition
  validates_uniqueness_of :definition, :scope => :user_story_id
  
  belongs_to :user_story
  belongs_to :developer, :foreign_key => 'developer_id', :class_name => "Person"
  # 
  # def open?
  #   self.user_story.done? ? false : true
  # end
  
  def complete?
    self.hours == 0
  end
  
  def incomplete?
    return false if self.developer
    if self.hours
      return self.hours > 0
    elsif self.hours == 0
      return false
    else
      return true
    end
      
  end
  
  def inprogress?
    if self.hours
      !self.developer.blank? && self.hours && self.hours > 0
    else
      !self.developer.blank?
    end
  end
  
end
