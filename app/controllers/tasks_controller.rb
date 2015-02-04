class TasksController < AbstractSecurityController
  before_filter :set_user_story
  before_filter :set_task, except: [:create]
  before_filter :set_sprint, only: [:complete, :create, :renounce, :claim]

  def create
    @task = @user_story.tasks.create!(task_params)
    update_burndowns(@task.sprint)
    @project.integrations_notify chat_message('created')
    json = { performed_by: current_person.name, refresh: true }.to_json
    REDIS.publish redis_key, json
  end

  def renounce
    @task.team_members.delete(current_person)
    @task.touch
    devs = @task.assignees.split(',')
    json = { notification: "#{current_person.name} renounced task of ##{@user_story.id}", performed_by: current_person.name, action: 'renounce', task_id: @task.id, task_hours: @task.hours, task_devs: devs, user_story_status: @user_story.status, user_story_id: @user_story.id }.to_json
    update_burndowns(@task.sprint)
    @project.integrations_notify chat_message('renounced')
    REDIS.publish redis_key, json
  end

  def claim
    @task.team_members << current_person
    @task.update_attribute(:done, false)
    devs = @task.assignees.split(',')
    json = { notification: "#{current_person.name} claimed task of ##{@user_story.id}", performed_by: current_person.name, action: 'claim', task_id: @task.id, task_hours: @task.hours, task_devs: devs, user_story_status: @user_story.status, user_story_id: @user_story.id }.to_json
    update_burndowns(@task.sprint)
    @project.integrations_notify chat_message('claimed')
    REDIS.publish redis_key, json
  end

  def complete
    @task.update_attribute(:done, true)
    devs = @task.assignees.split(',')
    json = { notification: "#{current_person.name} completed task of ##{@user_story.id}", performed_by: current_person.name, action: 'complete', task_id: @task.id, task_hours: @task.hours, task_devs: devs, user_story_status: @user_story.status, user_story_id: @user_story.id }.to_json
    update_burndowns(@task.sprint)
    @project.integrations_notify chat_message('completed')
    REDIS.publish redis_key, json
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

  def task_params
    params[:task].permit(:definition, :description)
  end

  def chat_message(event)
    "Task <strong>#{event.to_s}</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\""
  end

  def update_burndowns(sprint)
    calculate_todays_burndown(sprint)
    calculate_tomorrows_burndown(sprint)
    calculate_burndown_points
  end
end
