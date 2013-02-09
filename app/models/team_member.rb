class TeamMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :person

  # attr_accessible :title, :body
end
