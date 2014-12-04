class SprintMailer < ActionMailer::Base
  default from: "\"Agileista\" <#{EMAIL_FROM}>"

  def summary_email(person, sprint)
    @person = person
    @sprint = sprint
    @project = sprint.project
    person.update_attribute(:unsubscribe_token, SecureRandom.urlsafe_base64(25)) if person.unsubscribe_token.nil?
    @unsubscribe_token = person.unsubscribe_token
    @sprint_url = project_sprint_url(@project, sprint)
    @complete = sprint.user_stories.select {|us| us.status == "complete" }
    @inprogress = sprint.user_stories.select {|us| us.status == "inprogress" }
    @incomplete = sprint.user_stories.select {|us| us.status == "incomplete" }
    mail(to: person.email, subject: "[#{@project.name}] Daily Sprint Summary")
  end
end
