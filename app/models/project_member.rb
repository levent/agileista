class ProjectMember < ActiveRecord::Base
  
  belongs_to :project
  belongs_to :person

  validates_presence_of :project_id
  validates_presence_of :person_id
  
end
