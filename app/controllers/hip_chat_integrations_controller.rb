class HipChatIntegrationsController < AbstractSecurityController
  def create
    @hip_chat_integration = HipChatIntegration.new(params[:hip_chat_integration])
    @hip_chat_integration.project = @project
    if @hip_chat_integration.save
      flash[:notice] = "HipChat settings saved"
      redirect_to edit_project_path(@project)
    else
      flash[:error] = "HipChat settings could not be saved"
      redirect_to edit_project_path(@project)
    end
  end

  def update
    @hip_chat_integration = @project.hip_chat_integration
    if @hip_chat_integration.update_attributes(params[:hip_chat_integration])
      flash[:notice] = "HipChat settings updated"
      redirect_to edit_project_path(@project)
    else
      flash[:error] = "HipChat settings could not be updated"
      redirect_to edit_project_path(@project)
    end
  end
end
