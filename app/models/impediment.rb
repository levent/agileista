class Impediment < ActiveRecord::Base
  validates_presence_of :description
  validates_presence_of :person_id
  validates_presence_of :account_id
  belongs_to :team_member, :class_name => "TeamMember", :foreign_key => "person_id"
  belongs_to :account
  
  named_scope :unresolved, :conditions => {:resolved_at => nil}
  
  def resolve
    self.resolved_at = Time.now
    self.save
  end
  
  def to_s
    if self.status == "Resolved"
      "#{self.status} at #{self.resolved_at.strftime('%T %d/%m/%y')}"
    else
      "#{self.status} since #{self.created_at.strftime('%T %d/%m/%y')}"
    end
  end
  
  protected
  
  def status
    self.resolved_at.nil? ? "Active" : "Resolved"
  end
end
