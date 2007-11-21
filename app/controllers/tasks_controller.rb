class TasksController < ApplicationController
  
  before_filter :must_be_logged_in
  before_filter :must_be_team_member

  def create
  end

  def claim
    if request.post?
      begin
        @task = Task.find(params[:id])
      rescue
        @task = nil
      end
      unless @task.blank?
        @task.developer = Person.find_by_id_and_account_id(session[:user], session[:account])
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
