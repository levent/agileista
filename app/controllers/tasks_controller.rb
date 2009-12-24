class TasksController < AbstractSecurityController
  
  # ssl_required :create, :claim, :release, :move_up, :move_down
  before_filter :must_be_team_member
  before_filter :set_user_story, :only => [:show, :edit, :update, :destroy, :new, :create, :create_quick, :assign, :claim, :unclaim]
  before_filter :set_task, :only => [:show, :edit, :update, :destroy, :claim, :unclaim]

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
    redirect_to plan_sprint_path(:id => @user_story.sprint_id)
  end
  
  def assign
    task = @user_story.tasks.find(:first, :conditions => ["id = ?", params[:task_id]])
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
    render :json => {:error => error, :html_content => params.inspect, :sprint_id => @user_story.sprint_id}.to_json
  end
  
  def edit
  end
  
  def update
    if @task && @task.update_attributes(params[:task])
       flash[:notice] = "Task saved"
       if params[:from] == 'tb'
         redirect_to sprint_path(:id => @account.sprints.current.first)
       else
         redirect_to user_story_task_path(:id => @task, :user_story_id => @user_story)
       end
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
    @task.developers << current_user
    redirect_to sprint_path(:id => @account.sprints.current.first)
  end
  
  def unclaim
    @task.developers = @task.developers - [current_user]
    redirect_to sprint_path(:id => @account.sprints.current.first)
  end
  # 
  # def release
  #   if request.post?
  #     begin
  #       @task = Task.find(params[:id])
  #     rescue
  #       @task = nil
  #     end
  #     unless @task.blank?
  #       @task.developer = nil if @task.developer == Person.find(session[:user])
  #       @task.save
  #       flash[:notice] = "Task released successfully"
  #     end
  #   end
  #   redirect_to :back
  # end
  
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
  
end
