class TasksController < AbstractSecurityController
  before_action :set_user_story
  before_action :set_task, except: [:create]
  before_action :set_sprint, only: [:complete, :create, :renounce, :claim]
  after_action :update_burndowns, except: [:destroy]

  def create
    @task = @user_story.tasks.create!(task_params)
    @project.integrations_notify chat_message('created')
    TaskBoardNotification.new(@task, current_person).create.publish
  end

  def renounce
    @task.team_members.delete(current_person)
    @task.touch
    @project.integrations_notify chat_message('renounced')
    TaskBoardNotification.new(@task, current_person).renounce.publish
  end

  def claim
    @task.team_members << current_person
    @task.update_attribute(:done, false)
    @project.integrations_notify chat_message('claimed')
    TaskBoardNotification.new(@task, current_person).claim.publish
  end

  def complete
    @task.update_attribute(:done, true)
    @project.integrations_notify chat_message('completed')
    TaskBoardNotification.new(@task, current_person).complete.publish
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

  def update_burndowns
    calculate_todays_burndown(@task.sprint)
    calculate_tomorrows_burndown(@task.sprint)
    calculate_burndown_points
  end
end
