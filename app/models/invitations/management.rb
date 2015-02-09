module Invitations
  module Management
    def add_person_to_project(project)
      person = Person.where(email: email).first
      if person
        project.team_members.find_or_create_by!(person_id: person.id)
        return true
      else
        return false
      end
    end

    def create_and_notify_for_project(project)
      invitation = project.invitations.where(email: email).first_or_create
      if invitation.valid?
        NotificationMailer.invite_to_project(project, invitation).deliver_now
      else
        return false
      end
    end
  end
end
