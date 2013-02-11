class InvitationsController < AbstractSecurityController
  def new
    @invitation = @project.invitations.new
  end

  def create
    if person = Person.where(:email => params[:invitation][:email]).first
      TeamMember.find_or_create_by_project_id_and_person_id(@project.id, person.id)
      flash[:notice] = "#{person.name} added to project"
      redirect_to project_people_path(@project)
    elsif @invitation = @project.invitations.where(:email => params[:invitation][:email]).first_or_create!
      NotificationMailer.invite_to_project(@project, @invitation).deliver
      flash[:notice] = "Invite sent to #{@invitation.email}"
      redirect_to project_people_path(@project)
    else
      render :action => 'new'
    end
  end

  def destroy
    @project.invitations.find(params[:id]).destroy
    flash[:notice] = "Invitation removed"
    redirect_to project_people_path(@project)
  end
end
