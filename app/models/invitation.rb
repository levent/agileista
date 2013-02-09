class Invitation < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :email
  validates_presence_of :project_id
end
