class UnsubscribeController < ApplicationController
  def stop
    project = Project.find(params[:project_id])
    person = Person.find_by(unsubscribe_token: params[:id])
    if person
      team_member = project.team_members.where(person_id: person.id).first
      team_member.update_attribute(notify_by_email: false)
      flash[:notice] = "You will no longer receive email notifications"
    end
    redirect_to root_path
  end
end
