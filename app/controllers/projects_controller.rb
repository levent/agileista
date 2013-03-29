class ProjectsController < AbstractSecurityController
  before_filter :set_project_override, :only => [:edit, :destroy, :update]
  before_filter :must_be_account_holder, :only => [:edit, :destroy, :update]

  def index
    setup_projects_from_invitations
    @projects = current_person.projects.order('name')
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_person.projects.new(params[:project])
    if @project.save
      @project.scrum_master = current_person
      flash[:notice] = "Project created"
      redirect_to project_backlog_index_path(@project)
    else
      flash[:error] = "Project could not be created"
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:notice] = "Project settings saved"
      redirect_to :back
    else
      flash[:error] = "Project settings couldn't be saved"
      render :action => 'edit'
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = "Project removed"
      redirect_to root_path
    else
      flash[:error] = "Project could not be removed"
      render :action => 'edit'
    end
  end

  def generate_api_key
    current_person.update_attribute(:api_key, Digest::SHA256.hexdigest("#{Time.now}---#{rand(10000)}"))
    redirect_to :back
  end

  private

  def set_project_override
    @project = current_person.projects.find(params[:id])
  end

  def setup_projects_from_invitations
    invitations = Invitation.where(:email => current_person.email)
    invitations.each do |invite|
      team_member = TeamMember.where(:project_id => invite.project_id, :person_id => current_person.id).first_or_create!
      invite.destroy if team_member
    end
  end
end
