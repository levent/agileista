class BacklogController < AbstractSecurityController
  before_filter :project_user_stories ,:only => ['index', 'export', 'feed', 'sort']

  def index
    store_location
    @velocity = @project.average_velocity
    @uid = Digest::SHA1.hexdigest("backlog#{@project.id}")
    if params[:filter] == 'stale'
      @how_stale = calculate_staleness(params[:t])
      @user_stories = @user_stories.stale(@how_stale)
      load_story_points(false)
    else
      load_story_points
    end
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
    if params[:q]
      raise ArgumentError unless @account.id
      @user_stories = UserStory.search("#{params[:q]}", {:with => {:account_id => @account.id}}).page(params[:page])
    else
      flash[:notice] = "No user stories found"
      redirect_to :action => 'index' and return false
    end
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

  def calculate_staleness(t)
    if t =~ /^(\d+)(seconds|minute|minutes|hour|hours|day|days|week|weeks|month|months|year|years)$/
      duration = $1.to_i.send($2.to_sym)
      Time.now - duration
    else
      1.month.ago
    end
  end

  def load_story_points(cached = true)
    @story_points = REDIS.get("project:#{@project.id}:story_points") if cached
    unless @story_points
      @story_points = 0
      @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
      REDIS.set("project:#{@project.id}:story_points", @story_points) if cached
    end
  end
end
