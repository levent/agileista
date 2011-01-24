class Task < ActiveRecord::Base
  acts_as_list :scope => :user_story
  
  validates_presence_of :definition
  # Screws up in accepts_nested_attributes_for
  # validates_uniqueness_of :definition, :scope => :user_story_id
  
  belongs_to :user_story
  # belongs_to :developer, :foreign_key => 'developer_id', :class_name => "Person"
  
  has_many :task_developers
  has_many :developers, :through => :task_developers, :foreign_key => 'developer_id', :class_name => "Person", :uniq => true

  delegate :sprint, :to => :user_story, :allow_nil => true
  
  # named_scope :incomplete, :conditions => "developer_id IS NULL && (hours > 0 OR hours IS NULL)"
  # named_scope :inprogress, :conditions => "(developer_id IS NOT NULL AND hours > 0) OR (developer_id IS NOT NULL AND hours IS NULL)"
  named_scope :complete, :conditions => "hours = 0"
  
  # Similar to above, but we're using these in the user_story/show context
  named_scope :done, lambda { complete.scope(:find) }
  named_scope :not_done, :conditions => "hours > 0 OR hours IS NULL"
  
  after_save :calculate_burndown
  after_destroy :calculate_burndown
  
  def self.incomplete
    all(:conditions => "hours > 0 OR hours IS NULL").select {|x| x.developers.blank?}
  end
  
  def self.inprogress
    all(:conditions => "hours > 0 OR hours IS NULL").select {|x| x.developers.any?}
  end

  def calculate_burndown
    self.user_story.sprint.calculate_day_zero if self.sprint
  end
  
  def complete?
    self.hours == 0
  end
  
  def incomplete?
    return false if self.developers.any?
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
      !self.developers.blank? && self.hours && self.hours > 0
    else
      !self.developers.blank?
    end
  end
end
