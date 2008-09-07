require 'fastercsv'
class BacklogController < AbstractSecurityController
  ssl_required :feed
  ssl_allowed :index, :sort_release, :search
  before_filter :must_be_team_member, :only => ['sort_release']
  before_filter :account_user_stories ,:only => ['index', 'sort_release']

  def index
    params[:order] ? order = 'story_points DESC' : order = 'position'
    @user_stories = @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil], :order => order)
    @story_points = 0
    @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
    # @cloud = Tag.cloud(:conditions => ["tags.account_id = ?", @account.id])
    respond_to do |format|
      format.html {render :action => 'index.rhtml'}
      format.rss {render :action => 'index.rss.rxml', :layout => false}
      format.atom {render :action => 'index.atom.rxml', :layout => false}
    end
  end
  
  def export
    @user_stories = @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil], :order => 'position')    
    stream_csv do |csv|
      csv << ["ID",
        "Definition",
        "Description",
        "Story points",
        "Position",
        "Created at",
        "Last modified"]
      @user_stories.each do |a|
        csv << [a.id,
          a.definition,
          a.description,
          a.story_points,
          a.position,
          a.created_at.strftime('%d/%m/%y %T'),
          a.updated_at.strftime('%d/%m/%y %T')]
      end
    end
  end
  
  def feed
    @user_stories = @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil], :order => 'position')
    render :layout => false
  end
  
  def pdf
    @rails_pdf_name = "Backlog.pdf"
    @user_stories = @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil], :order => 'position')
    render :layout => false
  end
  
  def search
    if request.post? && params[:q]
      raise ArgumentError unless @account.id
      q = xapian_query(params[:q])
      @user_stories = ActsAsXapian::Search.new([UserStory], "#{q}", :limit => 100).results.collect {|r| r[:model]}
      @story_points = 0
      @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
    else
      flash[:notice] = "No user stories found"
      redirect_to :action => 'index' and return false
    end
  end
  
  def sort_release
    @user_stories.each do |story| 
      story.position = params['userstorylist'].index(story.id.to_s) + 1 
      story.save 
    end 
    render :nothing => true 
  end
  
  private 
  
  def tagged_account_user_stories(tag)
    t = Tag.find_by_name(tag.to_s)
    unless t.blank?
      t.taggables & @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil])
    else
      false
    end
  end

  def stream_csv
     filename = "current_backlog_#{Time.now.strftime('%Y%m%d%H%M')}.csv"    

     #this is required if you want this to work with IE
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

    render :text => Proc.new { |response, output|
      csv = FasterCSV.new(output, :row_sep => "\r\n") 
      yield csv
    }
  end
  
  def xapian_query(q)
    q.blank? ? sanitised_query = "active:yes AND account_id:#{@account.id}" : sanitised_query = "#{params[:q]} AND active:yes AND account_id:#{@account.id}"
    return sanitised_query
  end
end