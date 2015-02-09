class HipChatIntegration < ChatIntegration
  self.table_name = 'hip_chat_integrations'

  def required_fields_present?
    token.present? && room.present?
  end
end
