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
        calculate_tomorrows_burndown
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
      redirect_to sprints_path
    else
      flash[:error] = "Sprint couldn't be saved"
      render :action => 'edit'
    end
  end
  
  def plan
    store_location
    render_404 if @sprint && @sprint.finished?
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
    end
  end
  
  def calculate_burndown_points
    return nil unless @sprint
    burndowns = @sprint.burndowns
    @burndown_labels = burndowns.map{|burn| burn.created_on.strftime("%d %B %Y")}
    @burndown_data = burndowns.map{|burn| burn.hours_left}
  end
  
end