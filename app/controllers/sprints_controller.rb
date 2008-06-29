class SprintsController < AbstractSecurityController

  before_filter :iteration_length_must_be_specified
  before_filter :sprint_must_exist, :only => 'show'
  
  def index
    @sprints = @account.sprints
  end
  
  def show
    @current_sprint = @sprint
    if @sprint && @sprint.current?
    create_chart
      calculate_tomorrows_burndown
      respond_to do |format|
        format.html {render :action => 'task_board'}
      end
    else
    create_chart
      respond_to do |format|
        format.html
      end
    end
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