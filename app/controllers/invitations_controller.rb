class InvitationsController < AbstractSecurityController
  def new
    @invitation = @project.invitations.new
  end

  def create
    @invitation = Invitation.new(email: params[:invitation][:email])
    if @invitation.add_person_to_project(@project)
      flash[:notice] = "Person added to project"
      redirect_to project_people_path(@project)
    elsif @invitation.create_and_notify_for_project(@project)
      flash[:notice] = "Invite sent to #{params[:invitation][:email]}"
      redirect_to project_people_path(@project)
    else
      flash.now[:error] = "Invalid email address"
      render 'new'
    end
  end

  def destroy
    @project.invitations.find(params[:id]).destroy
    flash[:notice] = "Invitation removed"
    redirect_to project_people_path(@project)
  end
end
