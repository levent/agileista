class ConsoleController < AbstractSecurityController
  def index
    raise(ActionController::RoutingError, "No route matches 'console'") unless AccountStuff::TEAM_AGILEISTA.include?(current_person.email)
    @projects = Project.paginate(:page => params[:page], :per_page => 100).order('created_at DESC')
  end
end
