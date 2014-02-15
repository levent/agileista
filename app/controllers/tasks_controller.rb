class TasksController < AbstractSecurityController
  before_filter :set_user_story
  before_filter :set_task, except: [:create]
  before_filter :set_sprint, only: [:complete, :create, :renounce, :claim]

  def create
    @task = @user_story.tasks.create!(params[:task])
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    calculate_burndown_points
    @project.hipchat_notify("Task <strong>created</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\"")
    json = { :performed_by => current_person.name, :refresh => true }.to_json
    uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{@user_story.sprint_id}")
    REDIS.publish "pubsub.#{uid}", json
  end

  def renounce
    REDIS.del("task:#{@task.id}:assignees")
    @task.team_members.delete(current_person)
    @task.touch
    devs = @task.assignees.split(',')
    json = { :notification => "#{current_person.name} renounced task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'renounce', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{@user_story.sprint_id}")
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    calculate_burndown_points
    @project.hipchat_notify("Task <strong>renounced</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\"")
    REDIS.publish "pubsub.#{uid}", json.to_json
  end

  def claim
    REDIS.del("task:#{@task.id}:assignees")
    @task.team_members << current_person
    @task.update_attribute(:done, false)
    devs = @task.assignees.split(',')
    json = { :notification => "#{current_person.name} claimed task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'claim', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{@user_story.sprint_id}")
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    calculate_burndown_points
    @project.hipchat_notify("Task <strong>claimed</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\"")
    REDIS.publish "pubsub.#{uid}", json.to_json
  end

  def complete
    @task.update_attribute(:done, true)
    devs = @task.assignees.split(',')
    json = { :notification => "#{current_person.name} completed task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'complete', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{@user_story.sprint_id}")
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    calculate_burndown_points
    @project.hipchat_notify("Task <strong>completed</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\"")
    REDIS.publish "pubsub.#{uid}", json.to_json
  end

  def destroy
    @task.destroy && flash[:notice] = "Task deleted"
    redirect_to :back
  end

  private

  def set_task
    @task = @user_story.tasks.find(params[:id])
  end

  def set_sprint
    @sprint = @user_story.sprint
  end
end
