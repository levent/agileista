class SprintsController < AbstractSecurityController

  before_filter :must_be_team_member, :only => [:plan, :new, :edit, :update, :create]
  before_filter :iteration_length_must_be_specified
  before_filter :sprint_must_exist, :only => [:show, :overview, :edit, :plan, :update]
  
  def index
    @sprints = @account.sprints
  end
  
  def show
    @current_sprint = @sprint
    create_chart
    respond_to do |format|
      if @sprint && @sprint.current?
        calculate_tomorrows_burndown
        format.html {render :action => 'task_board'}
      else
        format.html
      end
    end
  end
  
  def new
    @sprint = @account.sprints.new
  end
  
  def create
    @sprint = @account.sprints.new(params[:sprint])
    if @sprint.save
      redirect_to sprints_path
    else
      render :action => 'new'
    end
  end
  
  def overview
  end
  
  def edit
  end
  
  def update
    if @sprint && @sprint.update_attributes(params[:sprint])
      redirect_to sprints_path
    else
      render :action => 'edit'
    end
  end
  
  def plan
    render_404 if @sprint && @sprint.finished?
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
  
end