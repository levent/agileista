class ReleasesController < AbstractSecurityController
  
  before_filter :must_be_logged_in
  before_filter :must_be_team_member, :except => [:index]
  before_filter :unplanned_estimated_user_stories, :only => [:show]
  
  def index
    @releases = @account.releases.find(:all, :order => 'releases.name, user_stories.position', :include => [:user_stories])
    # @account_user_stories = @account.user_stories.find(:all, :conditions => ['done = ? AND story_points IS NOT ?', 0, nil], :order => 'position')
    @velocity = params[:velocity] || 50
  end
  
  def new
    @release = Release.new
    @release.account = @account
  end
  
  def create
    @release = Release.new(params[:release])
    @release.account = @account
    if @release.save
      flash[:notice] = "Release saved successfully"
      redirect_to :action => 'index'
    else
      flash[:error] = "There were issues saving the release"
      render :action => 'new'
    end
  end
  
  def edit
    @release = @account.releases.find(params[:id])
  end
  
  def update
    @release = @account.releases.find(params[:id])
    @release.account = @account
    if @release.update_attributes(params[:release])
      flash[:notice] = "Release saved successfully"
      redirect_to :action => 'index'
    else
      flash[:error] = "There were issues saving the release"
      render :action => 'edit', :id => params[:id]
    end
  end
  
  def show
    @release = @account.releases.find(params[:id])
    if params[:velocity]
      @velocity = params[:velocity].to_i
      @sprints_left = (@release.end_date - Time.now) / 2.weeks
      @possible = @sprints_left * @velocity
    end
    # @account_user_stories = @account.user_stories.find(:all, :conditions => ['done = ? AND story_points IS NOT ?', 0, nil], :order => 'position')
  end

  def plan
    @release = @account.releases.find(params[:id])
    for us in @release.user_stories
      us.release = nil unless params[:user_stories].include?(us.id.to_s)
      us.save
    end
    for us in UserStory.find(:all, :conditions => ["id IN (?)", params[:user_stories]])
      us.release = @release
      us.save
    end
    redirect_to :action => 'index'
  end
  
end