class TasksController < AbstractSecurityController
  
  before_filter :must_be_team_member
  before_filter :set_user_story, :only => [:edit, :update, :destroy, :create_quick, :assign, :claim, :renounce, :complete]
  before_filter :set_task, :only => [:edit, :update, :destroy, :claim, :renounce, :complete]
  
  def create_quick
    @task = @user_story.tasks.new(:definition => @user_story.definition, :description => @user_story.description, :hours => 6)
    if @task.save
      flash[:notice] = "6hr task created from user story"
    else
      flash[:error] = "Task could not be created"
    end
    redirect_back_or(plan_sprint_path(:id => @user_story.sprint_id))
  end

  def renounce
    @task.team_members.delete(current_user)
    @task.save
    json = { :notification => "#{current_user.name} renounced task ##{@user_story.id}.#{@task.position}", :performed_by => current_user.name }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end

  def claim
    @task.team_members << current_user
    @task.save
    json = { :notification => "#{current_user.name} claimed task ##{@user_story.id}.#{@task.position}", :performed_by => current_user.name }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end

  def complete
    @task.update_attribute(:hours, 0)
    json = { :notification => "#{current_user.name} completed task ##{@user_story.id}.#{@task.position}", :performed_by => current_user.name }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end
  
  def update
    @task.update_attribute(:hours, params[:hours])
    json = { :notification => "#{current_user.name} updated task ##{@user_story.id}.#{@task.position}", :performed_by => current_user.name }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end
  
  def edit
  end
  
  def destroy
    @task.destroy && flash[:notice] = "Task deleted"
    redirect_to :back
  end

  private
  
  def truncate(string, length = 60)
    return string if string.length <= 60
    string[0...length-3] + "..."
  end
end
