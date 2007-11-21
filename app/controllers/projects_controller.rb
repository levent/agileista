class ProjectsController < ApplicationController
  
  before_filter :must_be_logged_in
  before_filter :must_be_team_member
  before_filter :project_must_exist, :only => [:edit, :update]
  
  # def index
  #   @projects = @account.projects
  # end
  
  def new
    @project = Project.new
  end
  
  def edit
    
  end
  
  def create
    if request.post?
      @project = Project.new(params[:project])
      @project.account = @account
      if @project.save
        flash[:notice] = "Project created successfully"
        redirect_to :controller => "/account"
      else
        flash[:error] = "There were errors creating the project"
        render :action => 'new'
      end
    end
  end
  
  def update
    if request.post?
      @project.update_attributes(params[:project])
      if @project.save
        flash[:notice] = "Project updated successfully"
        redirect_to :controller => "/project/overview", :action => "show", :id => @project
      else
        flash[:error] = "There were errors saving the changes"
        render :action => 'edit'
      end
    end
  end
  
end
