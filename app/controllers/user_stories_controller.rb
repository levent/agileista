class UserStoriesController < AbstractSecurityController
  before_filter :user_story_must_exist, only: [:update, :show, :edit, :delete, :destroy, :done, :copy, :plan, :unplan, :estimate]
  before_filter :set_sprint, only: [:plan, :unplan, :reorder]

  def estimate
    json = { estimator: current_person.name, estimator_id: current_person.id, story_points: params[:user_story][:story_points] }.to_json
    uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}poker#{@project.id}#{@user_story.id}")
    REDIS.publish "pubsub.#{uid}", json
  end

  def copy
    if @user_story.copy!
      flash[:notice] = "User story copied and added to backlog"
      notify_integrations(:user_story_copied)
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
    redirect_to edit_project_user_story_path(@project, @user_story)
  end

  def create
    @user_story = @project.user_stories.new(user_story_params)
    @user_story.person = current_person
    @user_story.backlog_order_position = :first

    if @user_story.save
      notify_integrations(:user_story_created)
      flash[:notice] = "User story created"
      redirect_to save_or_close_path(params[:commit])
    else
      @user_story.acceptance_criteria.build
      @user_story.tasks.build
      render 'new'
    end
  end

  def edit
    @uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}poker#{@project.id}#{@user_story.id}")
    @user_story.acceptance_criteria.build
    @user_story.tasks.build
  end

  def update
    if @user_story.update_attributes(user_story_params)
      flash[:notice] = "User story updated successfully"
      notify_integrations(:user_story_updated)
      redirect_to edit_project_user_story_path(@project, @user_story) and return false if params[:commit] == 'Save'
    else
      flash.now[:error] = "User story couldn't be updated"
      @user_story.acceptance_criteria.build
      @user_story.tasks.build
      render 'edit' and return false
    end
    redirect_back_or(project_backlog_index_path(@project))
  end

  def plan
    @user_story.add_to_sprint(@sprint)
    @sprint.expire_total_story_points
    points_planned = @sprint.user_stories.sum('story_points')
    notify_integrations(:user_story_planned)
    TaskBoardNotification.new(@user_story, nil, current_person).refresh.publish
    render json: {ok: true, points_planned: points_planned}.to_json
  end

  def unplan
    @user_story.remove_from_sprint(@sprint)
    @sprint.expire_total_story_points
    notify_integrations(:user_story_unplanned)
    TaskBoardNotification.new(@user_story, nil, current_person).refresh.publish
    respond_to do |format|
      format.html {
        flash[:notice] = "User story removed from sprint"
        redirect_to project_sprint_path(@project, @sprint)
      }
      format.json {
        points_planned = @sprint.user_stories.sum('story_points')
        render json: {ok: true, points_planned: points_planned}.to_json
      }
    end
  end

  def reorder
    sprint_element = @sprint.sprint_elements.where(user_story_id: params[:id]).first
    sprint_element.update_attribute(:sprint_position, params[:move_to]) if sprint_element
    render json: {ok: true}.to_json
  end

  def destroy
    if @user_story.destroy
      notify_integrations(:user_story_deleted)
      session[:return_to] = nil if session[:return_to].split("/").last == @user_story.id.to_s
      UserStory.index.refresh
      flash[:notice] = "User story deleted"
    end
    redirect_back_or(project_backlog_index_path(@project))
  end

  protected

  def set_sprint
    @sprint = @project.sprints.find(params[:sprint_id])
  end

  def user_story_must_exist
    @user_story = @project.user_stories.find(params[:id])
  end

  def user_story_params
    params[:user_story].permit(:definition, :story_points, :stakeholder, :cannot_be_estimated, :description, { acceptance_criteria_attributes: [:id, :detail, :_destroy]}, {tasks_attributes: [:id, :definition, :description, :_destroy]})
  end

  def save_or_close_path(commit_param)
    params[:commit] == 'Save' ? edit_project_user_story_path(@project, @user_story) : project_backlog_index_path(@project)
  end
end
