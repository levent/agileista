class SearchesController < AbstractSecurityController
  def show
    store_location
    params[:q] = '*' if params[:q].blank?
    @user_stories = UserStory.search_by_query(params[:q], params[:page], @project.id, params[:global] == 'true')
  rescue Tire::Search::SearchRequestFailed => e
    @user_stories = @project.user_stories.limit(0).paginate(:per_page => 0, :page => 1)
    flash[:error] = "Invalid search query"
  end
end
