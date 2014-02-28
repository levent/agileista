class SprintMailer < ActionMailer::Base
  default from: EMAIL_FROM

  def summary_email(person, sprint, project)
    @person = person
    @sprint = sprint
    @project = project
    @sprint_url = project_sprint_path(project, sprint)
    @complete = sprint.user_stories.select {|us| us.status == "complete" }
    @inprogress = sprint.user_stories.select {|us| us.status == "inprogress" }
    @incomplete = sprint.user_stories.select {|us| us.status == "incomplete" }
    mail(:to => person.email, :subject => "[Agileista] Sprint Summary")
  end
end
