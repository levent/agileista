class SlackIntegrationsController < AbstractSecurityController
  def create
    @slack_integration = SlackIntegration.new(params[:slack_integration])
    @slack_integration.project = @project
    if @slack_integration.save
      flash[:notice] = "Slack settings saved"
      redirect_to edit_project_path(@project)
    else
      flash[:error] = "Slack settings could not be saved"
      redirect_to edit_project_path(@project)
    end
  end

  def update
    @slack_integration = @project.slack_integration
    if @slack_integration.update_attributes(params[:slack_integration])
      flash[:notice] = "Slack settings updated"
      redirect_to edit_project_path(@project)
    else
      flash[:error] = "Slack settings could not be updated"
      redirect_to edit_project_path(@project)
    end
  end
end
