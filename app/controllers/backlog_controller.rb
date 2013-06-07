class BacklogController < AbstractSecurityController
  before_filter :project_user_stories ,:only => ['index', 'export', 'feed', 'sort']

  def index
    store_location
    @velocity = @project.average_velocity
    @uid = Digest::SHA1.hexdigest("backlog#{@project.id}")
    load_story_points
    respond_to do |format|
      format.html do
      end
      format.csv do
        render text: @user_stories.to_csv
      end
    end
  end

  def search
    store_location
    params[:q] = '*' if params[:q].blank?
    raise ArgumentError unless @project.id
    @user_stories = UserStory.search(per_page: 100, page: params[:page], load: true) do |search|
      search.query do |query|
        query.boolean do |boolean|
          boolean.must { |must| must.string params[:q], default_operator: "AND" }
          boolean.must { |must| must.term :project_id, @project.id }
        end
      end
      search.filter(:missing, :field => 'sprint_id' )
    end
  rescue Tire::Search::SearchRequestFailed => e
    @user_stories = @project.user_stories.limit(0).paginate(:per_page => 0, :page => 1)
    flash[:error] = "Invalid search query"
  end

  def sort
    @user_stories.find(params[:user_story_id]).update_attribute(:backlog_order_position, params[:move_to])
    json = {
      :notification => "Backlog reordered by #{current_person.name}",
      :performed_by => current_person.name
    }
    uid = Digest::SHA1.hexdigest("backlog#{@project.id}")
    Juggernaut.publish(uid, json)
    render :json => {:ok => true, :velocity => @project.average_velocity}.to_json
  end

  private

  def load_story_points
    @story_points = REDIS.get("project:#{@project.id}:story_points")
    unless @story_points
      @story_points = 0
      @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
      REDIS.set("project:#{@project.id}:story_points", @story_points)
      REDIS.expire("project:#{@project.id}:story_points", 900)
    end
  end
end
