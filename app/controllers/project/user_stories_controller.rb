class Project::UserStoriesController < ApplicationController
  before_filter :must_be_logged_in
  before_filter :project_must_exist
  
  def list
  end
  
  def new
    @user_story = UserStory.new
  end
  
  def create
    if request.post?
      @user_story = UserStory.new(params[:user_story])
      @user_story.project = @project
      if @user_story.save
        flash[:notice] = "User story created successfully"
        redirect_to :action => "list", :id => @project
      else
        flash[:error] = "There were errors creating the user story"
        render :action => 'new'
      end
    end
  end
  
  def edit
    @user_story = @project.user_stories.find(params[:user_story_id])
  end
  
  def update
    if request.post?
      @user_story = @project.user_stories.find(params[:user_story_id])
      if @user_story.update_attributes(params[:user_story])
        flash[:notice] = "User story updated successfully"
        redirect_to :action => "list", :id => @project
      else
        flash[:error] = "There were errors updating the user story"
        render :action => 'edit', :user_story_id => @user_story
      end
    end
  end
  
  def move_up
    if request.post?
      @project.user_stories.find(params[:user_story]).move_higher
      flash[:notice] = "User story moved up"
      redirect_to :action => 'list', :id => @project
    else
      redirect_to :action => 'list', :id => @project
    end
  end
  
  def move_down
    if request.post?
      @project.user_stories.find(params[:user_story]).move_lower
      flash[:notice] = "User story moved down"
      redirect_to :action => 'list', :id => @project
    else
      redirect_to :action => 'list', :id => @project
    end
  end
  
end
