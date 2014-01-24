class BacklogController < AbstractSecurityController
  before_filter :project_user_stories ,:only => ['index', 'export', 'feed', 'sort']

  def index
    store_location
    @velocity = @project.average_velocity
    @uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}backlog#{@project.id}")
    load_story_points
    respond_to do |format|
      format.html do
      end
      format.csv do
        render text: @user_stories.to_csv
      end
    end
  end

  def sort
    @user_stories.find(params[:user_story_id]).update_attribute(:backlog_order_position, params[:move_to])
    json = {
      :notification => "Backlog reordered by #{current_person.name}",
      :performed_by => current_person.name
    }
    uid = Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}backlog#{@project.id}")
    REDIS.publish "pubsub.#{uid}", json.to_json
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

  # excludes DONE
  def project_user_stories
    @user_stories = @project.user_stories.unassigned.rank(:backlog_order)
  end

end
