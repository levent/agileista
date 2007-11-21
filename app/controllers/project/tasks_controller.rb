class Project::TasksController < ApplicationController
  
  before_filter :must_be_logged_in
  before_filter :project_must_exist
  before_filter :user_story_must_exist
  
  def show
    
  end
  
  def new
  end
  
  def create
    if request.post?
      @task = Task.new(params[:task])
      # breakpoint
      @task.user_story = @user_story
      if @task.save
        flash[:notice] = "Task created successfully"
        redirect_to :action => "show", :id => @project, :user_story => @user_story
      else
        flash[:error] = "There were errors creating the task"
        render :action => 'new', :id => @project, :user_story => @user_story
      end
    end
  end
  
  def edit
    @task = @project.user_stories.find(params[:user_story]).tasks.find(params[:task_id])
  end
  
  def update
    if request.post?
      @task = @project.user_stories.find(params[:user_story]).tasks.find(params[:task_id])
      if @task.update_attributes(params[:task])
        flash[:notice] = "Task updated successfully"
        redirect_to :action => "show", :id => @project, :user_story => @user_story
      else
        flash[:error] = "There were errors updating the task"
        render :action => 'edit', :user_story => @user_story, :task_id => @task
      end
    end
  end
  
  def move_up
    if request.post?
      @project.user_stories.find(params[:user_story]).tasks.find(params[:task]).move_higher
      flash[:notice] = "Task moved up"
      redirect_to :action => 'show', :id => @project, :user_story => @user_story
    else
      redirect_to :action => 'show', :id => @project, :user_story => @user_story
    end
  end
  
  def move_down
    if request.post?
      @project.user_stories.find(params[:user_story]).tasks.find(params[:task]).move_lower
      flash[:notice] = "Task moved down"
      redirect_to :action => 'show', :id => @project, :user_story => @user_story
    else
      redirect_to :action => 'show', :id => @project, :user_story => @user_story
    end
  end
  
end