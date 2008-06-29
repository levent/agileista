class SprintsController < AbstractSecurityController
  
  before_filter :sprint_must_exist, :only => 'show'
  
  def index
    @sprints = @account.sprints
  end
  
  def show
    respond_to do |format|
      if @sprint.current?
        format.html {render :action => 'task_board'}
      else
        format.html
      end
    end
  end
  
end