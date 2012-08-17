class ConsoleController < AbstractSecurityController
  def index
    raise(ActionController::RoutingError, "No route matches 'console'") unless AccountStuff::TEAM_AGILEISTA.include?(current_user.email)
    @accounts = Account.page(params[:page]).order('created_at DESC')
  end
end
