class TeamMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  validates :person_id, presence: true
  validates :project_id, presence: true
end
