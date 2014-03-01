class NotificationMailer < ActionMailer::Base
  default from: "\"Agileista\" <#{EMAIL_FROM}>"

  def invite_to_project(project, invitation)
    @project = project
    @invitation = invitation
    @url = new_person_registration_url
    mail(:to => invitation.email, :subject => "[Agileista] You have been invited to join a project")
  end
end
