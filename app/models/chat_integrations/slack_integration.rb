class SlackIntegration < ChatIntegration
  self.table_name = 'slack_integrations'

  def required_fields_present?
    team.present? && token.present? && channel.present?
  end
end
