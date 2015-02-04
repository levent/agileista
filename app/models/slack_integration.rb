class SlackIntegration < ActiveRecord::Base
#  attr_accessible :team, :token, :channel

  belongs_to :project
  validates_presence_of :project_id

  def required_fields_present?
    self.team.present? && self.token.present? && self.channel.present?
  end
end
