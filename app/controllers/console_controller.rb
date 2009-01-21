class ConsoleController < AbstractSecurityController
  def index
    raise(ActionController::RoutingError, "No route matches 'console'") unless AccountStuff::TEAM_AGILEISTA.include?(current_user.email)
    @accounts = Account.all(:order => "created_at DESC").paginate :page => params[:page]
  end
end