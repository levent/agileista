class TasksController < AbstractSecurityController
  
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
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_user.name} renounced task of ##{@user_story.id}", :performed_by => current_user.name, :action => 'renounce', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end

  def claim
    @task.team_members << current_user
    @task.save
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_user.name} claimed task of ##{@user_story.id}", :performed_by => current_user.name, :action => 'claim', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end

  def complete
    @task.update_attribute(:hours, 0)
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_user.name} completed task of ##{@user_story.id}", :performed_by => current_user.name, :action => 'complete', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end
  
  def update
    @task.update_attributes({:hours => params[:hours]})
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_user.name} updated task of ##{@user_story.id}", :performed_by => current_user.name, :action => 'update', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
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
