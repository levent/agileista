class BacklogController < AbstractSecurityController
  # ssl_required :feed
  # ssl_allowed :index, :sort, :search
  before_filter :account_user_stories ,:only => ['index', 'export', 'feed', 'sort']

  def index
    store_location
    @velocity = @account.average_velocity
    @uid = Digest::SHA1.hexdigest("backlog#{@account.id}")
    if params[:filter] == 'stale'
      @how_stale = calculate_staleness(params[:t])
      @user_stories = @user_stories.stale(@how_stale)
      load_story_points(false)
    else
      load_story_points
    end
    respond_to do |format|
      format.html do
        if @account.user_stories.blank?
          render :action => 'get_started' 
        end
      end
      format.csv do
        render text: @user_stories.to_csv
      end
    end
  end

  def grid
    cookies[:backlog] = 'grid'
    redirect_to backlog_url
  end

  def list
    cookies[:backlog] = 'list'
    redirect_to backlog_url
  end
  
  def feed
    render :layout => false
  end
  
  def search
    store_location
    if params[:q]
      raise ArgumentError unless @account.id
      @user_stories = UserStory.search("#{params[:q]}", {:with => {:account_id => @account.id}, :limit => 1000, :per_page => 20, :page => params[:page]})
    else
      flash[:notice] = "No user stories found"
      redirect_to :action => 'index' and return false
    end
  end
  
  def sort
    @user_stories.find(params[:user_story_id]).update_attribute(:backlog_order_position, params[:move_to])
    json = {
      :notification => "Backlog reordered by #{current_user.name}",
      :performed_by => current_user.name
    }
    uid = Digest::SHA1.hexdigest("backlog#{@account.id}")
    Juggernaut.publish(uid, json)
    render :json => {:ok => true, :velocity => @account.average_velocity}.to_json
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
    @story_points = REDIS.get("account:#{@account.id}:story_points") if cached
    unless @story_points
      @story_points = 0
      @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
      REDIS.set("account:#{@account.id}:story_points", @story_points) if cached
    end
  end
end
