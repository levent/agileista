class SprintsController < AbstractSecurityController
  
  before_filter :sprint_must_exist, :only => 'show'
  
  def index
    @sprints = @account.sprints
  end
  
  def show
    
  end
  
end