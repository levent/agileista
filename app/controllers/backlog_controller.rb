require 'fastercsv'
class BacklogController < AbstractSecurityController
  ssl_required :feed
  ssl_allowed :index, :sort, :search
  before_filter :must_be_team_member, :only => ['sort']
  before_filter :account_user_stories ,:only => ['index', 'export', 'feed', 'sort']

  def index
    @story_points = 0
    @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
    respond_to do |format|
      format.html {render :action => 'get_started' if @account.user_stories.blank?}
      format.csv do
        render_csv("current_backlog_#{Time.now.strftime('%Y%m%d%H%M')}")
      end
    end
  end
  
  def feed
    render :layout => false
  end
  
  def search
    if params[:q]
      raise ArgumentError unless @account.id
      @user_stories = UserStory.search("#{params[:q]}", {:with => {:account_id => @account.id}, :limit => 1000, :per_page => 20, :page => params[:page]})
    else
      flash[:notice] = "No user stories found"
      redirect_to :action => 'index' and return false
    end
  end
  
  def sort
    split_by = "&item[]="
    items = params[:user_stories].split(split_by)
    items[0] = items[0].gsub('item[]=', '')
    @user_stories.each do |us|
      us.position = items.index(us.id.to_s) + 1
      us.save
    end
    render :json => {:ok => true}.to_json
  end
  
  private
  
  def render_csv(filename = nil)
    filename ||= params[:action]
    filename += '.csv'

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain" 
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
      headers['Expires'] = "0" 
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
    end

    render :layout => false
  end
end