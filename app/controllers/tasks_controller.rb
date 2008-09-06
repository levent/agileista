class TasksController < AbstractSecurityController
  
  # ssl_required :create, :claim, :release, :move_up, :move_down
  before_filter :must_be_team_member
  before_filter :set_user_story, :only => [:show, :edit, :update, :destroy]
  before_filter :set_task, :only => [:show, :edit, :update, :destroy]

  def show
  end
  
  def edit
  end

  def create
  end
  
  def update
    if @task && @task.update_attributes(params[:task])
       flash[:notice] = "Sprint saved"
       redirect_to user_story_task_path(:id => @task, :user_story_id => @user_story)
     else
       flash[:error] = "Sprint couldn't be saved"
       render :action => 'edit'
     end
  end
  
  def destroy
  end

  def claim
    if request.post?
      begin
        @task = Task.find(params[:id])
      rescue
        @task = nil
      end
      unless @task.blank?
        @task.developer = current_user
        @task.save
        flash[:notice] = "Task assigned successfully"
      end
    end
    redirect_to :back
  end

  def release
    if request.post?
      begin
        @task = Task.find(params[:id])
      rescue
        @task = nil
      end
      unless @task.blank?
        @task.developer = nil if @task.developer == Person.find(session[:user])
        @task.save
        flash[:notice] = "Task released successfully"
      end
    end
    redirect_to :back
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
  
end
