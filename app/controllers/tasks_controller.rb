class TasksController < AbstractSecurityController
  
  # ssl_required :create, :claim, :release, :move_up, :move_down
  before_filter :must_be_team_member
  before_filter :set_user_story, :only => [:show, :edit, :update, :destroy, :new, :create, :create_quick, :assign, :claim]
  before_filter :set_task, :only => [:show, :edit, :update, :destroy, :claim]

  def show
  end

  def new
  end

  def create
    @task = @user_story.tasks.new(params[:task])
    if @task && @task.save
      flash[:notice] = "Task saved"
      redirect_to new_user_story_task_path(:user_story_id => @user_story)
    else
      flash[:error] = "Task couldn't be saved"
      render :action => 'new'
    end
  end
  
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
        task.developers = []
        task.save
      when "inprogress"
        task.developers = [current_user] unless task.developers.any?
        task.save
      when "complete"
        task.hours = 0
        task.save
      else
        error = "Please try again"
      end
    else
      error = "You cannot move tasks across user stories"
    end
    devs = task.developers.any? ? "<strong>#{task.developers.map(&:name).join(', ')}</strong>" : "<strong>Nobody</strong>"
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
      :definition => "#{task_def}... #{devs}" }
    Juggernaut.publish("sid#{@user_story.sprint_id}", json)
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
      @task.developers.delete(current_user)
    when 'taskclaim'
      @task.developers << current_user
    end
    @task.update_attributes(params[:task])
    if @task.developers.any?
      devs = "<strong>#{@task.developers.map(&:name).join(', ')}</strong>"
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
      :definition => "#{task_def} #{devs}" }
    Juggernaut.publish("sid#{@user_story.sprint_id}", json)
    render :json => json
  end

  def move_up
    if request.post?
      @account.user_stories.find(params[:user_story_id]).tasks.find(params[:id]).move_higher
      flash[:notice] = "Task moved up"
    end
    redirect_to :controller => 'user_stories', :action => 'edit', :id => params[:user_story_id], :sprint_id => params[:sprint_id]
  end

  def move_down
    if request.post?
      @account.user_stories.find(params[:user_story_id]).tasks.find(params[:id]).move_lower
      flash[:notice] = "Task moved down"
    end
    redirect_to :controller => 'user_stories', :action => 'edit', :id => params[:user_story_id], :sprint_id => params[:sprint_id]
  end
  
  private
  
  def update_task_developers(commit, task)
    case commit
    when "Claim"
      task.developers << current_user
    when "Renounce"
      task.developers.delete(current_user)
    end
  end

  def truncate(string, length = 60)
    return string if string.length <= 60
    string[0...length-3] + "..."
  end
end
