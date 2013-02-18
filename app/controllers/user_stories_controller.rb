class UserStoriesController < AbstractSecurityController

  before_filter :user_story_must_exist, :only => [:update, :show, :edit, :delete, :destroy, :done, :copy, :plan, :unplan]
  before_filter :set_sprint, :only => [:plan, :unplan, :reorder]

  def copy
    if @user_story.copy
      flash[:notice] = "User story copied and added to backlog"
    else
      flash[:error] = "The user story could not be copied"
    end
    redirect_to :back
  end

  def new
    @user_story = UserStory.new
    @user_story.acceptance_criteria.build
    @user_story.tasks.build
  end

  def show
    respond_to do |format|
      format.json {
        render :json => @user_story
      }
    end
  end

  def create
    @user_story = @project.user_stories.new(params[:user_story])
    @user_story.account = @account
    @user_story.person = current_person
    @user_story.sprint = @sprint

    @user_story.backlog_order_position = :first

    if @user_story.save
      if @sprint
        SprintElement.find_or_create_by_sprint_id_and_user_story_id(@sprint.id, @user_story.id)
        redirect_to project_sprint_path(@project, @sprint)
      else
        redirect_to project_backlog_index_path(@project)
      end

    else
      @user_story.acceptance_criteria.build
      @user_story.tasks.build
      render :action => 'new'
    end
  end

  def edit
    @user_story.acceptance_criteria.build
    @user_story.tasks.build
  end

  def update
    if @user_story.update_attributes(params[:user_story])
      flash[:notice] = "User story updated successfully"
    else
      flash[:error] = "User story couldn't be updated"
      @user_story.acceptance_criteria.build
      @user_story.tasks.build
      render :action => 'edit' and return false
    end
    redirect_back_or(project_backlog_index_path(@project))
  end
  
  def plan
    @user_story.sprint = @sprint
    @user_story.save!
    SprintElement.find_or_create_by_sprint_id_and_user_story_id(@sprint.id, @user_story.id)
    points_planned = @sprint.user_stories.sum('story_points')
    hours_left = @sprint.hours_left
    render :json => {:ok => true, :points_planned => points_planned, :hours_left => hours_left}.to_json
  end
  
  def unplan
    @user_story.sprint = nil
    @user_story.backlog_order_position = :first
    @user_story.save!
    SprintElement.destroy_all("sprint_id = #{@sprint.id} AND user_story_id = #{@user_story.id}")
    respond_to do |format|
      format.html {
        flash[:notice] = "User story removed from sprint"
        redirect_to sprint_path(@sprint)
      }
      format.json {
        hours_left = @sprint.hours_left
        points_planned = @sprint.user_stories.sum('story_points')
        render :json => {:ok => true, :points_planned => points_planned, :hours_left => hours_left}.to_json
      }
    end
  end

  def reorder
    sprint_element = @sprint.sprint_elements.where(:user_story_id => params[:id]).first
    sprint_element.update_attribute(:sprint_position, params[:move_to]) if sprint_element
    render :json => {:ok => true}.to_json
  end

  def destroy
    if @user_story.destroy
      session[:return_to] = nil if session[:return_to].split("/").last == @user_story.id.to_s
      flash[:notice] = "User story deleted"
    end
    redirect_back_or(backlog_url)
  end

  protected

  def set_sprint
    @sprint = @project.sprints.find(params[:sprint_id])
  end

end
