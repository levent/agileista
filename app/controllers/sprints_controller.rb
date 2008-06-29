class SprintsController < AbstractSecurityController
  
  def index
    @sprints = @account.sprints
  end
  
end