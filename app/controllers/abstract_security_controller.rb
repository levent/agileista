class AbstractSecurityController < ApplicationController
  prepend_before_filter :authenticate_person!
  before_filter :set_project

  private

  def redirect_back_or(default)
    redirect_to(return_to || default)
    clear_return_to
  end

  def store_location
    if request.get?
      session[:return_to] = request.url
      session[:return_to] = "/backlog" if session[:return_to] == "/backlog.atom"
    end
  end

  def return_to
    session[:return_to] || params[:return_to]
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def set_user_story
    @user_story = @project.user_stories.find(params[:user_story_id])
  end

  def set_project
    @project = current_person.projects.find(params[:project_id]) if params[:project_id]
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "No such project"
    redirect_to projects_path
  end

  def must_be_account_holder
    current_person.scrum_master_for?(@project) ? true : (redirect_to project_backlog_index_path(@project) and return false)
  end

  def load_charts
    return nil unless @sprint
    burndowns = @sprint.burndowns
    @chart_data = burndowns.collect {|burn| {date: burn.created_on.iso8601, hours_left: burn.hours_left, story_points_complete: burn.story_points_complete, story_points_remaining: burn.story_points_remaining}}
    @chart_xscale = [@sprint.start_at.iso8601.to_s, @sprint.end_at.iso8601.to_s]
  end

  def notify_integrations(event)
    host = request.env['HTTP_HOST']
    message = ChatMessage.new(host, project: @project, sprint: @sprint, person: current_person, user_story: @user_story, task: @task).send(event)
    @project.integrations_notify(message)
  end
end
