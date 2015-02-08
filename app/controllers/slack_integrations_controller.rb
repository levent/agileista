class SlackIntegrationsController < ChatIntegrationsController

  private

  def chat_klass
    SlackIntegration
  end

  def chat_integration_params
    params[:slack_integration].permit(:team, :token, :channel)
  end
end
