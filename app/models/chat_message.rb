class ChatMessage
  attr_accessor :host

  attr_accessor :project
  attr_accessor :sprint
  attr_accessor :person
  attr_accessor :user_story
  attr_accessor :task

  def initialize(host, params)
    self.host = host

    self.project = params[:project]
    self.sprint = params[:sprint]
    self.person = params[:person]
    self.user_story = params[:user_story]
    self.task = params[:task]
  end

  def sprint_created
    sprint_event(:created)
  end

  def sprint_updated
    sprint_event(:updated)
  end

  def user_story_planned
    user_story_event(:planned)
  end

  def user_story_unplanned
    user_story_event(:unplanned)
  end

  def user_story_copied
    user_story_event(:copied)
  end

  def user_story_created
    user_story_event(:created)
  end

  def user_story_updated
    user_story_event(:updated)
  end

  def user_story_deleted
    "##{user_story.id} <strong>deleted</strong> by #{person.name}: \"#{user_story.definition}\""
  end

  def task_created
    task_event(:created)
  end

  def task_renounced
    task_event(:renounced)
  end

  def task_claimed
    task_event(:claimed)
  end

  def task_completed
    task_event(:completed)
  end

  private

  def rails_routes
    Rails.application.routes.url_helpers
  end

  def user_story_event(event)
    "<a href=\"#{rails_routes.edit_project_user_story_url(project, user_story, host: host)}\">##{user_story.id}</a> <strong>#{event}</strong> by #{person.name}: \"#{user_story.definition}\""
  end

  def sprint_event(event)
    "Sprint <a href=\"#{Rails.application.routes.url_helpers.project_sprint_url(project, sprint, host: host)}\">##{sprint.id}</a> <strong>#{event}</strong> by #{person.name}: \"#{sprint.name}\""
  end

  def task_event(event)
    "Task <strong>#{event}</strong> on <a href=\"#{rails_routes.edit_project_user_story_url(project, user_story, host: host)}\">##{user_story.id}</a> by #{person.name}: \"#{task.definition}\""
  end
end
