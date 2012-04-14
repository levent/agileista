class TasksController < AbstractSecurityController
  
  before_filter :must_be_team_member
  before_filter :set_user_story, :only => [:edit, :update, :destroy, :create_quick, :assign, :claim]
  before_filter :set_task, :only => [:edit, :update, :destroy, :claim]
  
  def create_quick
    @task = @user_story.tasks.new(:definition => @user_story.definition, :description => @user_story.description, :hours => 6)
    if @task.save
      flash[:notice] = "6hr task created from user story"
    else
      flash[:error] = "Task could not be created"
    end
    redirect_back_or(plan_sprint_path(:id => @user_story.sprint_id))
  end
  
  def assign
    task = @user_story.tasks.find(params[:task_id])
    error = ''
    if task
      case params[:onto]
      when "incomplete"
        task.team_members = []
        task.save
        message = "#{current_user.name} renounced task ##{@user_story.id}.#{task.position}"
      when "inprogress"
        task.team_members = [current_user] unless task.team_members.any?
        task.save
        message = "#{current_user.name} claimed task ##{@user_story.id}.#{task.position}"
      when "complete"
        task.hours = 0
        task.save
        message = "#{current_user.name} completed task ##{@user_story.id}.#{task.position}"
      else
        error = "Please try again"
      end
    else
      error = "You cannot move tasks across user stories"
    end
    devs = task.team_members.any? ? "<strong>#{task.team_members.map(&:name).join(', ')}</strong>" : "<strong>Nobody</strong>"
    if @user_story.inprogress?
      status = "inprogress"
    elsif @user_story.complete?
      status = "complete"
    else
      status = ""
    end
    task_def = truncate(task.definition)
    json = {
      :error => error,
      :sprint_id => @user_story.sprint_id,
      :user_story_id => @user_story.id,
      :task_id => task.id,
      :hours_left => task.hours,
      :onto => params[:onto],
      :user_story_status => status,
      :definition => "#{task_def}... #{devs}",
      :notification => message,
      :performed_by => current_user.name
    }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
    render :json => json
  end
  
  def edit
  end
  
  def update
    update_task_developers(params[:commit], @task)
    if @task && @task.update_attributes(params[:task])
      flash[:notice] = "Task saved"
      redirect_back_or(edit_user_story_url(@user_story, :anchor => "user_story_tasks"))
    else
      flash[:error] = "Task couldn't be saved"
      render :action => 'edit'
    end
  end
  
  def destroy
    @task.destroy && flash[:notice] = "Task deleted"
    redirect_to :back
  end

  def claim
    case params[:submit]
    when 'taskrenounce'
      @task.team_members.delete(current_user)
      message = "#{current_user.name} renounced task ##{@user_story.id}.#{@task.position}"
    when 'taskclaim'
      @task.team_members << current_user
      message = "#{current_user.name} claimed task ##{@user_story.id}.#{@task.position}"
    else
      message = "#{current_user.name} updated task ##{@user_story.id}.#{@task.position}"
    end
    @task.update_attributes(params[:task])
    if @task.team_members.any?
      devs = "<strong>#{@task.team_members.map(&:name).join(', ')}</strong>"
      @task.hours.to_i > 0 ? onto = 'inprogress' : onto = 'complete'
    else
      devs = "<strong>Nobody</strong>"
      onto = 'incomplete'
    end
    if @user_story.inprogress?
      status = "inprogress"
    elsif @user_story.complete?
      status = "complete"
    else
      status = ""
    end

    task_def = truncate(@task.definition)

    json = {
      :sprint_id => @user_story.sprint_id,
      :user_story_id => @user_story.id,
      :task_id => @task.id,
      :hours_left => @task.hours,
      :onto => onto,
      :user_story_status => status,
      :definition => "#{task_def} #{devs}",
      :notification => message,
      :performed_by => current_user.name
    }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
    render :json => json
  end
  
  private
  
  def update_task_developers(commit, task)
    case commit
    when "Claim"
      task.team_members << current_user
    when "Renounce"
      task.team_members.delete(current_user)
    end
  end

  def truncate(string, length = 60)
    return string if string.length <= 60
    string[0...length-3] + "..."
  end
end
