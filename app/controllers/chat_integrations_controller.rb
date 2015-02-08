class ChatIntegrationsController < AbstractSecurityController
  def create
    @chat_integration = chat_klass.new(chat_integration_params)
    @chat_integration.project = @project
    if @chat_integration.save
      flash[:notice] = "Settings saved"
      redirect_to edit_project_path(@project)
    else
      flash[:error] = "Settings could not be saved"
      redirect_to edit_project_path(@project)
    end
  end

  def update
    @chat_integration = @project.send(chat_klass.name.underscore)
    if @chat_integration.update_attributes(chat_integration_params)
      flash[:notice] = "Settings updated"
      redirect_to edit_project_path(@project)
    else
      flash[:error] = "Settings could not be updated"
      redirect_to edit_project_path(@project)
    end
  end
end
