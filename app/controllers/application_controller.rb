class ApplicationController < ActionController::Base
  include AccountStuff
  include SslRequirement
  
  helper :all
  
  # require_dependency 'tag'
  # require_dependency 'tagging'
  
  filter_parameter_logging :password

  protected
  
  def render_csv(filename = nil)
    filename ||= params[:action]
    filename += '.csv'

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain" 
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
      headers['Expires'] = "0" 
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
    end

    render :layout => false
  end
  
  def ssl_required?
    return false if (local_request? || ['test', 'cucumber'].include?(Rails.env))
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
      redirect_to backlog_index_url and return false
    end
  end
  
  def must_be_team_member
    current_user.is_a?(TeamMember) ? true : (redirect_to backlog_index_url and return false)
  end
  
  def must_be_account_holder
    current_user.account_holder? ? true : (redirect_to backlog_index_url and return false)
  end
  
  # excludes DONE
  def account_user_stories
     @user_stories = @account.user_stories.unassigned('position')
  end
  
  def calculate_tomorrows_burndown
    @burndown = Burndown.find_or_create_by_sprint_id_and_created_on(@current_sprint.id, Date.tomorrow)
    @burndown.hours_left = @current_sprint.hours_left
    @burndown.save
  end

end