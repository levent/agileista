require 'fastercsv'
class SprintsController < AbstractSecurityController

  before_filter :must_be_team_member, :only => [:plan, :new, :edit, :update, :create, :destroy]
  before_filter :iteration_length_must_be_specified
  before_filter :sprint_must_exist, :only => [:show, :overview, :edit, :plan, :update, :destroy]
  
  def index
    @sprints = @account.sprints
  end
  
  def show
    store_location
    @current_sprint = @sprint
    calculate_burndown_points
    # raise @burndown_labels_and_data
    respond_to do |format|
      if @sprint && @sprint.current?
        calculate_todays_burndown
        calculate_tomorrows_burndown
        @uid = Digest::SHA1.hexdigest("exclusiveshit#{@sprint.id}")
        format.html {render :action => 'task_board'}
      else
        format.html
        format.csv do
          render_csv("sprint_#{@sprint.id}_#{Time.now.strftime('%Y%m%d%H%M')}")
        end
      end
    end
  end
  
  def new
    @sprint = @account.sprints.new
  end
  
  def create
    @sprint = @account.sprints.new(params[:sprint])
    set_start_at
    if @sprint.save
      flash[:notice] = "Sprint saved"
      redirect_to sprints_path
    else
      flash[:error] = "Sprint couldn't be saved"
      render :action => 'new'
    end
  end
  
  def overview
  end
  
  def edit
  end
  
  def update
    if @sprint && @sprint.update_attributes(params[:sprint])
      flash[:notice] = "Sprint saved"
      redirect_back_or(sprints_path)
    else
      flash[:error] = "Sprint couldn't be saved"
      render :action => 'edit'
    end
  end
  
  def plan
    store_location
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
  
  def render_404
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end
  
  def iteration_length_must_be_specified
    if @account.iteration_length.blank?
      flash[:notice] = "Please specify an iteration length first"
      redirect_to :controller => 'account', :action => 'settings'
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
  
  def calculate_burndown_points
    return nil unless @sprint
    burndowns = @sprint.burndowns
    @flot_burnup = []
    @flot_burndown = burndowns.collect {|burn| [burn.created_on.to_time.to_i * 1000, burn.hours_left || 'null']}
    @flot_burnup << burndowns.collect {|burn| [burn.created_on.to_time.to_i * 1000, burn.story_points_complete || 'null']} 
    @flot_burnup << burndowns.collect {|burn| [burn.created_on.to_time.to_i * 1000, burn.story_points_remaining || 'null']}
    @sprint.start_at.to_date.upto @sprint.end_at.to_date do |date|
      @flot_burndown << [date.to_time.to_i * 1000, 'null']
      @flot_burnup[0] << [date.to_time.to_i * 1000, 'null']
      @flot_burnup[1] << [date.to_time.to_i * 1000, 'null']
    end
  end
  
end
