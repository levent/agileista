class TaskDeveloper < ActiveRecord::Base
  belongs_to :team_member, :foreign_key => 'developer_id'
  belongs_to :task
end
