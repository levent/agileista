class ConsoleController < AbstractSecurityController
  before_filter :team_agileista_only

  def index
    @projects = Project.paginate(:page => params[:page], :per_page => 100).order('created_at DESC')
  end

  def search
    q = params[:q]
    q = '*' if q.blank?
    @user_stories = UserStory.search(per_page: 100, page: params[:page], load: true) do |search|
      search.query do |query|
        query.boolean do |boolean|
          boolean.must { |must| must.string q, default_operator: "AND" }
          boolean.must { |must| must.term :done, 0 }
        end
      end
      search.filter(:missing, :field => 'sprint_id' )
    end
  end

  private

  def team_agileista_only
    raise(ActionController::RoutingError, "No route matches 'console'") unless AccountStuff::TEAM_AGILEISTA.include?(current_person.email)
  end
end
