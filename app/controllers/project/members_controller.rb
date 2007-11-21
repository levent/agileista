class Project::MembersController < ApplicationController
  
  before_filter :must_be_logged_in
  before_filter :project_must_exist
  
  def add
    
  end
  
  def create
    if request.post?
      @project_member = ProjectMember.new(params[:project_member])
      @project_member.project = @project
      if @project_member.save
        flash[:notice] = "Project member added successfully"
        redirect_to :action => "add", :id => @project
      else
        flash[:error] = "There were errors adding the project member"
        render :action => 'add', :id => @project
      end
    end
  end
  
end
