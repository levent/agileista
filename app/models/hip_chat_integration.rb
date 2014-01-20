class HipChatIntegration < ActiveRecord::Base
  attr_accessible :token, :room, :notify

  belongs_to :project
  validates_presence_of :project_id

  def required_fields_present?
    self.token.present? && self.room.present?
  end
end
