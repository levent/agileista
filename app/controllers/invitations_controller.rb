class InvitationsController < AbstractSecurityController
  def new
    @invitation = @project.invitations.new
  end

  def create
    if @invitation = @project.invitations.first_or_create(params[:invitation])
      NotificationMailer.invite_to_project(@project, @invitation).deliver
      flash[:notice] = "Invite sent to #{@invitation.email}"
      redirect_to project_people_path(@project)
    else
      render :action => 'new'
    end
  end
end
