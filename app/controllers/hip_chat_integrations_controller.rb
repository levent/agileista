class HipChatIntegrationsController < ChatIntegrationsController

  private

  def chat_klass
    HipChatIntegration
  end

  def chat_integration_params
    params[:hip_chat_integration].permit(:token, :room, :notify)
  end
end
