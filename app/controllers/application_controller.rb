require 'account_stuff'
class ApplicationController < ActionController::Base
  force_ssl
  protect_from_forgery
  include AccountStuff

  protected

  def ssl_required?
    return false if (local_request? || ['development', 'test'].include?(Rails.env))
    super
  end

  def user_story_must_exist
    @user_story = @account.user_stories.find(params[:id])
  end

  def sprint_must_exist
    begin
      @sprint = @account.sprints.find(params[:id])
    rescue
      flash[:error] = "No such sprint"
      redirect_to sprints_path and return false
    end
  end

  def set_user_story
    @user_story = @account.user_stories.find(params[:user_story_id])
  end

  def set_task
    begin
      @task = @user_story.tasks.find(params[:id])
    rescue
      flash[:error] = "No such task"
      redirect_to backlog_url and return false
    end
  end

  def must_be_account_holder
    current_user.account_holder? ? true : (redirect_to backlog_url and return false)
  end

  # excludes DONE
  def account_user_stories
    @user_stories = @account.user_stories.unassigned.rank(:backlog_order)
  end

  def calculate_todays_burndown
    return unless @current_sprint.start_at.to_date == Date.today
    @burndown = Burndown.find_or_create_by_sprint_id_and_created_on(@current_sprint.id, Date.today)
    @burndown.story_points_remaining = @current_sprint.total_story_points
    @burndown.story_points_complete = 0
    @burndown.hours_left = nil
    @burndown.save!
  end

  def calculate_tomorrows_burndown
    @burndown = Burndown.find_or_create_by_sprint_id_and_created_on(@current_sprint.id, Date.tomorrow)
    @burndown.hours_left = @current_sprint.hours_left
    @burndown.story_points_complete = @current_sprint.story_points_burned
    @burndown.story_points_remaining = @current_sprint.total_story_points
    @burndown.save
  end

  def calculate_end_burndown
    burndown = Burndown.find_or_create_by_sprint_id_and_created_on(@current_sprint.id, 1.day.from_now(@current_sprint.end_at).to_date)
    burndown.hours_left = @current_sprint.hours_left
    burndown.story_points_complete = @current_sprint.story_points_burned
    burndown.story_points_remaining = @current_sprint.total_story_points
    burndown.save
  end

end
