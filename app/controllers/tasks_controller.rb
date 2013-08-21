class TasksController < AbstractSecurityController
  before_filter :set_user_story
  before_filter :set_task, :except => [:create]

  def create
    @task = @user_story.tasks.create!(params[:task])
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    hipchat_notify("Task <strong>created</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\"")
  end

  def renounce
    @task.team_members.delete(current_person)
    @task.touch
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_person.name} renounced task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'renounce', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    hipchat_notify("Task <strong>renounced</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\"")
    Juggernaut.publish(uid, json)
  end

  def claim
    @task.team_members << current_person
    @task.update_attribute(:hours, 1)
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_person.name} claimed task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'claim', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    hipchat_notify("Task <strong>claimed</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\"")
    Juggernaut.publish(uid, json)
  end

  def complete
    @task.update_attribute(:hours, 0)
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_person.name} completed task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'complete', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    hipchat_notify("Task <strong>completed</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\"")
    Juggernaut.publish(uid, json)
  end

  def destroy
    @task.destroy && flash[:notice] = "Task deleted"
    redirect_to :back
  end

  private

  def set_task
    @task = @user_story.tasks.find(params[:id])
  end

  def truncate(string, length = 60)
    return string if string.length <= 60
    string[0...length-3] + "..."
  end
end
