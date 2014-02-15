class TeamMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :person

  attr_accessible :person, :scrum_master
end
