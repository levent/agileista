class SprintElement < ActiveRecord::Base
  acts_as_list :scope => :sprint
  has_many :sprint_changes, :as => :auditable
  
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
  
  def audit_create(person)
    SprintChange.create(:kind => "create", :sprint_id => self.sprint_id, :auditable => self, :major => true, :details => "User story #{self.user_story.id} added by #{person.name}", :person => person)
  rescue NoMethodError => e
    Rails.logger.warn("[AUDIT FAIL]: SprintElement create #{self.inspect}")
  end
  
  def audit_destroy(person)
    SprintChange.create(:kind => "destroy", :sprint_id => self.sprint_id, :auditable => self, :major => true, :details => "User story #{self.user_story.id} removed by #{person.name}", :person => person)
  rescue NoMethodError => e
    Rails.logger.warn("[AUDIT FAIL]: SprintElement destroy #{self.inspect}")
  end
  
  def audit_update(person)
    SprintChange.create(:kind => "update", :sprint_id => self.sprint_id, :auditable => self, :major => false, :details => "User story #{self.user_story.id} changed by #{person.name}", :person => person, :changes => self.send(:changed_attributes))
  rescue NoMethodError => e
    Rails.logger.warn("[AUDIT FAIL]: SprintElement update #{self.inspect}")
  end
end