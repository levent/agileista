class UserStoriesController < ApplicationController

  before_filter :must_be_logged_in
  before_filter :must_be_team_member, :except => [:add, :create_via_add]
  before_filter :user_story_must_exist, :only => ['update', 'add_to_sprint', 'remove_from_sprint', 'show', 'create_task', 'edit_task', 'update_task', 'create_acceptance_criterium',
    :edit, :move_up, :move_down, :delete, :delete_acceptance_criterium, :new_task, :tasks, :done, :unfinished, :show_task, :destroy_task, :copy]
  
  def copy
    if request.post? && @user_story.copy
      flash[:notice] = "User story copied and added to backlog"
    else
      flash[:error] = "The user story could not be copied"
    end
    redirect_to :back
  end
  
  def new
    @user_story = UserStory.new
  end
  
  def add
  end
  
  def show
    @task = Task.new
  end
  
  def create
    if request.post?
      # in case save fails
      @tags = params[:tags]
      @themes = params[:themes] || ""
      @user_story = UserStory.new(params[:user_story])
      @user_story.account = @account
      @user_story.person = current_user
      if @user_story.save
        @user_story.tag_with(params[:tags])
        @user_story.theme_with(params[:themes])
        
        if params[:commit] == "Add at start of backlog"
          @user_story.move_to_top
        else
          @user_story.move_to_bottom
        end
        
        flash[:notice] = "User story created successfully"
        redirect_to :controller => 'user_stories', :action => 'edit', :id => @user_story
        
      else
        flash[:error] = "There were errors creating the user story"
        render :action => 'new'
      end
    end
  end

  def create_via_add
    if request.post?
      @user_story = UserStory.new
      @user_story.definition = params[:user_story][:definition]
      @user_story.description = params[:user_story][:description]
      @user_story.account = @account
      @user_story.person = current_user
      if @user_story.save
        flash[:notice] = "User story created successfully"
        redirect_to :controller => 'backlog'
      else
        flash[:error] = "There were errors creating the user story"
        render :action => 'add'
      end
    end
  end
  
  def done
    if request.post?
      @user_story.done = 1
      for task in @user_story.tasks
        task.hours = 0
        task.save
      end
      if @user_story.save
        flash[:notice] = 'User story completed'
      else
        flash[:error] = 'User story could not be completed'
      end
      redirect_to :controller => 'sprint' and return false
    end
    
  end
  
  def unfinished
    if request.post?
      @user_story.done = 0
      if @user_story.save
        flash[:notice] = 'User story reopened'
      else
        flash[:error] = 'User story could not be reopened'
      end
      redirect_to :controller => 'sprint' and return false
    end
  end

  def new_task
    @task = Task.new
    @sprint = @account.sprints.find(params[:sprint_id]) if params[:sprint_id]
  end
  
  def tasks
    unless params[:task_id]
      @task = Task.new
    else
      @task = Task.find(params[:task_id])
    end
    render :action => 'new_task'
  end
  
  def create_task
    if request.post?
      @acceptance_criterium = AcceptanceCriterium.new
      @task = Task.new(params[:task])
      @task.user_story = @user_story
      if @task.save
        calculate_dayzero(params[:sprint_id])
        flash[:notice] = "Task created successfully"
        redirect_to :controller => 'user_stories', :action => "new_task", :id => @user_story, :sprint_id => params[:sprint_id]
      else
        flash[:error] = "There were errors creating the task"
        render :controller => 'user_stories', :action => 'new_task', :id => @user_story, :sprint_id => params[:sprint_id]
      end
    end
  end
  
  def create_acceptance_criterium
    if request.post? or request.xhr?
      @task = Task.new
      @acceptance_criterium = AcceptanceCriterium.new(params[:acceptance_criterium])
      @acceptance_criterium.user_story = @user_story
      if @acceptance_criterium.save
        flash[:notice] = "Criterium created successfully"
        redirect_to :action => "edit", :id => @user_story, :sprint_id => params[:sprint_id] unless request.xhr?
        render :partial => 'acceptance_criteria' if request.xhr?
      else
        flash[:error] = "There were errors adding criteria"
        render :controller => 'user_stories', :action => 'edit', :id => @user_story, :sprint_id => params[:sprint_id] unless request.xhr?
        render :partial => 'acceptance_criteria' if request.xhr?
      end
    end
  end
  
  def delete_acceptance_criterium
    if request.xhr? or request.post?
      @acceptance_criterium = @user_story.acceptance_criteria.find(params[:crit_id])
      if @acceptance_criterium.destroy
        render :partial => 'user_stories/acceptance_criteria' if request.xhr?
      end
    end
  end
  
  def show_task
    @task = @user_story.tasks.find(params[:task_id])
  end
  
  def edit_task
    @task = @user_story.tasks.find(params[:task_id])
  end
  
  def destroy_task
    if request.post? || request.delete?
      @task = @user_story.tasks.find(params[:task_id])
      if @task.destroy
        flash[:notice] = "Task deleted successfully"
      end
    else
      flash[:error] = "There were errors deleting the task"
    end
    redirect_to :controller => 'sprint'
  end
  
  def update_task
    if request.post?
      @task = @user_story.tasks.find(params[:task_id])
      if @task.update_attributes(params[:task])
        flash[:notice] = "Task update successfully"
        # redirect_to :action => "show", :id => @user_story, :sprint_id => params[:sprint_id]
        if params[:from]  == 'planning'
          redirect_to :controller => 'sprint_planning', :action => 'show', :id => params[:sprint_id] and return false
        elsif params[:from] == 'tasks'
          redirect_to :controller => 'user_stories', :action => 'new_task', :id => @user_story, :sprint_id => params[:sprint_id] and return false
        elsif params[:from] == 'tb'
          redirect_to :controller => 'user_stories', :action => 'edit_task', :id => @user_story, :task_id => @task, :from => params[:from] and return false
        else
          redirect_to :controller => 'user_stories', :action => 'edit', :id => @user_story, :sprint_id => params[:sprint_id] and return false
        end
      else
        flash[:error] = "There were errors updating the task"
        render :controller => 'user_stories', :action => 'show', :id => @user_story, :sprint_id => params[:sprint_id]
      end
    end
  end
  
  def edit
    # @user_story = @account.user_stories.find(params[:id])
    @tags = @user_story.tags.map(&:name).join(' ')
    @task = Task.new
    @acceptance_criterium = AcceptanceCriterium.new
  end
  
  # def edit2
  #   @user_story = @account.user_stories.find(params[:id])
  #   @task = Task.new
  #   @acceptance_criterium = AcceptanceCriterium.new
  # end
  
  # def update2
  #   # breakpoint
  # end
  
  def update
    if request.post?
      @tags = params[:tags]
      @themes = params[:themes] || ""
      if @user_story.update_attributes(params[:user_story])
        @user_story.tag_with(@tags)
        @user_story.theme_with(@themes)
        flash[:notice] = "User story updated successfully"
      else
        flash[:error] = "User story couldn't be updated"
        @acceptance_criterium = AcceptanceCriterium.new
        render :action => 'edit' and return false
      end
    end
    if params[:sprint_id]
      redirect_to :controller => 'sprint_planning', :action => 'show', :id => params[:sprint_id]
    elsif params[:from] && params[:from] == 'themes'
      redirect_to :controller => 'themes'
    elsif params[:from] && params[:from] == 'show'
      redirect_to :action => 'show', :id => @user_story
    else
      redirect_to :controller => 'backlog'
    end
  end
  
  def add_to_sprint
    if request.post?
      @sprint = Sprint.find(params[:sprint_id])
      @user_story.sprint = @sprint
      @sprint_element = SprintElement.create(:sprint_id => params[:sprint_id], :user_story => @user_story)
      if @user_story.save
        flash[:notice] = "User story added to sprint"
      else
        flash[:error] = "User story couldn't be added"
        render :action => 'edit'
      end
    end
    redirect_to :controller => 'sprint_planning', :action => 'show', :id => params[:sprint_id]
  end
  
  def plan_sprint
    if request.xhr?
      @sprint = Sprint.find(params[:sprint_id])
      if params['committed'] && !params['committed'].blank?
        params['committed'].each do |x|
          @us = UserStory.find(x)
          @us.sprint = @sprint
          @us.save
          SprintElement.find_or_create_by_sprint_id_and_user_story_id(params[:sprint_id], @us.id)
        end
      end
      if params['estimated'] && !params['estimated'].blank?
        params['estimated'].each do |x|
          @us = UserStory.find(x)
          @us.sprint = nil
          @us.save
          SprintElement.find(:all, :conditions => ["sprint_id = ? AND user_story_id = ?", @sprint.id, @us.id]).collect{|se| se.destroy}
        end
      end
      respond_to do |format|
        format.html {redirect_to :controller => 'sprint_planning', :action => 'show', :id => params[:sprint_id]}
        format.js {render :update do |page|
          page.redirect_to :controller => 'sprint_planning', :action => 'show', :id => params[:sprint_id]
        end}
      end
    end
  end
  
  def remove_from_sprint
    if request.post?
      @user_story.sprint = nil
      @sprint = Sprint.find(params[:sprint_id])
      SprintElement.find(:all, :conditions => ["sprint_id = ? AND user_story_id = ?", @sprint.id, @user_story.id]).collect{|se| se.destroy}
      if @user_story.save
        flash[:notice] = "User story removed from sprint"
      else
        flash[:error] = "User story couldn't be removed"
        render :action => 'edit'
      end
    end
    redirect_to :controller => 'sprint_planning', :action => 'show', :id => params[:sprint_id]
  end
  
  def move_up
    if request.post?
      @user_story.move_higher
      flash[:notice] = "User story moved up"
    end
    redirect_to :controller => 'account'
  end
  
  def move_down
    if request.post?
      @user_story.move_lower
      flash[:notice] = "User story moved down"
    end
    redirect_to :controller => 'account'
  end
  
  def delete
    if request.post?
      @user_story.destroy
      flash[:notice] = "User story deleted"
    end
    redirect_to :controller => 'backlog'
  end

  private
  
  def user_story_must_exist
    begin
      @user_story = @account.user_stories.find(params[:id])
    rescue
      return false
    end
    if @user_story && @user_story.class == UserStory
      return true
    else
      redirect_to :controller => '/backlog' and return false
    end
  end
  
end
