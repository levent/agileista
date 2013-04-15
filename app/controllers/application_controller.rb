class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :ensure_domain
  before_filter :set_project

  protected

  TheDomain = 'app.agileista.com'

  def ensure_domain
    if request.env['HTTP_HOST'] != TheDomain && Rails.env == "production"
      redirect_to "https://#{TheDomain}"
    end
  end

  def set_project
    @project = current_person.projects.find(params[:project_id]) if params[:project_id]
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "No such project"
    redirect_to root_path
  end

  def ssl_required?
    return false if (local_request? || ['development', 'test'].include?(Rails.env))
    super
  end

  def user_story_must_exist
    @user_story = @project.user_stories.find(params[:id])
  end

  def sprint_must_exist
    begin
      @sprint = @project.sprints.find(params[:id])
    rescue
      flash[:error] = "No such sprint"
      redirect_to project_sprints_path(@project) and return false
    end
  end

  def set_user_story
    @user_story = @project.user_stories.find(params[:user_story_id])
  end

  def must_be_account_holder
    current_person.scrum_master_for?(@project) ? true : (redirect_to project_backlog_index_path(@project) and return false)
  end

  # excludes DONE
  def project_user_stories
    @user_stories = @project.user_stories.unassigned.rank(:backlog_order)
  end

  def calculate_todays_burndown(sprint)
    return if sprint.nil?
    return unless sprint.start_at.to_date == Date.today
    Resque.enqueue(CalculateBurnJob, Date.today, sprint.id)
  end

  def calculate_tomorrows_burndown(sprint)
    return if sprint.nil?
    Resque.enqueue(CalculateBurnJob, Date.tomorrow, sprint.id)
  end

  def calculate_end_burndown(sprint)
    return if sprint.nil?
    Resque.enqueue(CalculateBurnJob, 1.day.from_now(sprint.end_at).to_date, sprint.id)
  end

end
