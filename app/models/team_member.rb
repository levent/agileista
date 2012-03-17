class TeamMember < Person
  include Gravtastic
  gravtastic

  has_many :task_developers, :foreign_key => "developer_id"
  has_many :tasks, :through => :task_developers
end
