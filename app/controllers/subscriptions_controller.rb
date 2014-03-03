class SubscriptionsController < AbstractSecurityController
  skip_before_filter :authenticate_person!, only: [:stop]
  skip_before_filter :set_project, only: [:stop]

  def on
    team_member = @project.team_members.where(person_id: current_person.id).first
    team_member.update_attribute(:notify_by_email, true)
    flash[:notice] = "Notification emails enabled"
    redirect_to project_people_path(@project)
  end

  def off
    team_member = @project.team_members.where(person_id: current_person.id).first
    team_member.update_attribute(:notify_by_email, false)
    flash[:notice] = "Notification emails turned off"
    redirect_to project_people_path(@project)
  end

  def stop
    project = Project.find(params[:project_id])
    person = Person.find_by(unsubscribe_token: params[:id])
    if person
      team_member = project.team_members.where(person_id: person.id).first
      team_member.update_attribute(:notify_by_email, false)
      flash[:notice] = "You will no longer receive email notifications"
    end
    redirect_to root_path
  end
end
