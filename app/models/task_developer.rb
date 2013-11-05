class TaskDeveloper < ActiveRecord::Base
  belongs_to :team_member, :foreign_key => 'developer_id', :class_name => "Person"
  belongs_to :task, touch: true
end
