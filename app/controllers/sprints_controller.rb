class SprintsController < AbstractSecurityController

  before_filter :iteration_length_must_be_specified
  before_filter :sprint_must_exist, :only => [:show, :overview, :edit, :plan]
  
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
  
  def overview
  end
  
  def edit
  end
  
  def plan
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404 if @sprint && @sprint.finished?
  end
  
  private 
  
  def iteration_length_must_be_specified
    if @account.iteration_length.blank?
      flash[:notice] = "Please specify an iteration length first"
      redirect_to :controller => 'account', :action => 'settings'
      return false 
    end
  end
  
end