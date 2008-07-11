class Impediment < ActiveRecord::Base
  validates_presence_of :description
  validates_presence_of :person_id
  validates_presence_of :account_id
  belongs_to :team_member, :class_name => "TeamMember", :foreign_key => "person_id"
  belongs_to :account
  
  def resolve
    self.resolved_at = Time.now
    self.save
  end
end
