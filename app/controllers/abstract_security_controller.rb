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

  def calculate_todays_burndown(sprint)
    return if sprint.nil?
    return unless sprint.start_at.to_date == Date.today
    CalculateBurnWorker.perform_async(Date.today, sprint.id)
  end

  def calculate_tomorrows_burndown(sprint)
    return if sprint.nil?
    CalculateBurnWorker.perform_async(Date.tomorrow, sprint.id)
  end

  def calculate_end_burndown(sprint)
    return if sprint.nil?
    CalculateBurnWorker.perform_async(1.day.from_now(sprint.end_at).to_date, sprint.id)
  end

  def hipchat_notify(message)
    hip_chat_integration = @project.try(:hip_chat_integration)
    if hip_chat_integration && hip_chat_integration.required_fields_present?
      HipChatWorker.perform_async(@project.hip_chat_integration.token, @project.hip_chat_integration.room, @project.hip_chat_integration.notify?, message)
    end
  end
end
