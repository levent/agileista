class SprintsController < AbstractSecurityController

  before_action :must_be_account_holder, only: [:set_stats]
  before_action :iteration_length_must_be_specified
  before_action :sprint_must_exist, only: [:show, :review, :edit, :plan, :update, :destroy, :set_stats]
  before_action :load_charts, only: [:show, :review]
  after_action :calculate_burndowns, only: [:show, :review]

  def index
    store_location
    @sprints = @project.sprints
    @velocity = @project.average_velocity
    @cint_lo, @cint_hi = Velocity.confidence_interval(@sprints.finished.statistically_significant(@project).map(&:calculated_velocity))
    @stats_since_sprint = Velocity.stats_significant_since_sprint_id(@project.id)
  end

  def show
    @task_board = TaskBoard.new(@sprint)
    store_location
    @uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{@sprint.id}")
  end

  def review
    store_location
  end

  def set_stats
    REDIS.set("project:#{@project.id}:stats_since:sprint_id", @sprint.id)
    REDIS.set("project:#{@project.id}:stats_since", @sprint.start_at)
    redirect_to project_sprints_path(@project)
  end

  def new
    @sprint = @project.sprints.new
  end

  def create
    @sprint = @project.sprints.new(sprint_params)
    if @sprint.save
      flash[:notice] = "Sprint created"
      notify_integrations(:sprint_created)
      redirect_to project_sprints_path(@project)
    else
      flash.now[:error] = "Sprint could not be created"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @sprint && @sprint.update_attributes(sprint_params)
      flash[:notice] = "Sprint saved"
      notify_integrations(:sprint_updated)
      redirect_back_or(project_sprints_path(@project))
    else
      flash.now[:error] = "Sprint could not be saved"
      render 'edit'
    end
  end

  def plan
    store_location
    @velocity = @project.average_velocity
    @planned_stories = @sprint.user_stories.includes(:person)
    @backlog_stories = @project.user_stories.estimated
  end

  def destroy
    if @sprint && @sprint.destroy
      flash[:notice] = "Sprint deleted"
    else
      flash[:error] = "Sprint couldn't be deleted"
    end
    redirect_to sprints_path
  end

  private

  def iteration_length_must_be_specified
    if @project.iteration_length.blank?
      flash[:notice] = "Please specify an iteration length first"
      redirect_to edit_project_path(@project)
      return false
    end
  end

  def calculate_burndowns
    if @sprint && @sprint.current?
      Burndown.calculate_today(@sprint)
      Burndown.calculate_tomorrow(@sprint)
    elsif @sprint.finished?
      Burndown.calculate_end(@sprint)
    end
  end

  def sprint_must_exist
    begin
      @sprint = @project.sprints.find(params[:id])
    rescue
      flash[:error] = "No such sprint"
      redirect_to project_sprints_path(@project) and return false
    end
  end

  def sprint_params
    params[:sprint].permit(:name, :start_at, :end_at, :goal)
  end
end
