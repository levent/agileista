class ProjectsController < AbstractSecurityController
  def index
    @projects = current_person.projects.order('name')
  end

  def edit
    @project = current_person.projects.find(params[:id])
  end

  def update
    @project = current_person.projects.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:notice] = "Settings saved"
      redirect_to :back
    else
      flash[:error] = "Settings couldn't be saved"
      render :action => 'edit'
    end
  end

  def generate_api_key
    current_person.update_attribute(:api_key, Digest::SHA256.hexdigest("#{Time.now}---#{rand(10000)}"))
    redirect_to :back
  end
end
