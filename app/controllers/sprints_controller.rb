class SprintsController < AbstractSecurityController

  before_filter :iteration_length_must_be_specified
  before_filter :sprint_must_exist, :only => 'show'
  
  def index
    @sprints = @account.sprints
  end
  
  def show
    if @sprint && @sprint.current?
      @current_sprint = @sprint
      calculate_tomorrows_burndown
      respond_to do |format|
        format.html {render :action => 'task_board'}
      end
    else
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