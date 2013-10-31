class SprintsController < AbstractSecurityController

  before_filter :must_be_account_holder, :only => [:set_stats]
  before_filter :iteration_length_must_be_specified
  before_filter :sprint_must_exist, :only => [:show, :edit, :plan, :update, :destroy, :set_stats]

  def index
    store_location
    @sprints = @project.sprints
    @velocity = @project.average_velocity
    @cint_lo, @cint_hi = Velocity.confidence_interval(@sprints.finished.statistically_significant(@project).map(&:calculated_velocity))
    @stats_since_sprint = Velocity.stats_significant_since_sprint_id(@project.id)
  end

  def show
    @sprint = @project.sprints.where(:id => params[:id]).includes(:user_stories => [{:tasks => :team_members}]).first
    store_location
    @current_sprint = @sprint
    calculate_burndown_points
    @uid = Digest::SHA1.hexdigest("exclusiveshit#{@sprint.id}")
    respond_to do |format|
      format.html {
        calculate_burndown_if_needed(@sprint)
      }
      format.json do
        render :json => @sprint
      end
    end
  end

  def review
    @sprint = @project.sprints.where(:id => params[:id]).includes(:user_stories => :acceptance_criteria).limit(1).first
    store_location
    calculate_burndown_if_needed(@sprint)
    calculate_burndown_points
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
    @sprint = @project.sprints.new(params[:sprint])
    set_start_at
    if @sprint.save
      flash[:notice] = "Sprint created"
      hipchat_notify("Sprint <a href=\"#{project_sprint_url(@project, @sprint)}\">##{@sprint.id}</a> <strong>created</strong> by #{current_person.name}: \"#{@sprint.name}\"")
      redirect_to project_sprints_path(@project)
    else
      flash[:error] = "Sprint could not be created"
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @sprint && @sprint.update_attributes(params[:sprint])
      flash[:notice] = "Sprint saved"
      hipchat_notify("Sprint <a href=\"#{project_sprint_url(@project, @sprint)}\">##{@sprint.id}</a> <strong>updated</strong> by #{current_person.name}: \"#{@sprint.name}\"")
      redirect_back_or(project_sprints_path(@project))
    else
      flash[:error] = "Sprint couldn't be saved"
      render :action => 'edit'
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

  def set_start_at
    if @sprint.start_at.blank? && params[:from]
      @sprint.start_at = Date.new(params[:from][:year].to_i, params[:from][:month].to_i, params[:from][:day].to_i).strftime("%Y-%m-%d %H:%M:%S")
    elsif @sprint.start_at.blank?
      @sprint.start_at = Date.today
    end
  end

  def calculate_burndown_if_needed(sprint)
    if sprint && sprint.current?
      calculate_todays_burndown(sprint)
      calculate_tomorrows_burndown(sprint)
    elsif sprint.finished?
      calculate_end_burndown(sprint)
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
end
