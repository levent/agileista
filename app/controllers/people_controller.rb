class PeopleController < AbstractSecurityController

  def index
    @people = @project.people.order('name')
    @invitations = @project.invitations.order('email')
    @email_notifications = @project.team_members.where(notify_by_email: true).collect(&:person_id)
  end

end

