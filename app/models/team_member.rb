class TeamMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  validates_presence_of :person_id
  validates_presence_of :project_id

  attr_accessible :person, :scrum_master, :person_id
end
