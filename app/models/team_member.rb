class TeamMember < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :project
  belongs_to :person
end
