require 'fastercsv'
class BacklogController < AbstractSecurityController
  ssl_required :feed
  ssl_allowed :index, :sort, :search
  before_filter :must_be_team_member, :only => ['sort']
  before_filter :account_user_stories ,:only => ['index', 'export', 'feed', 'pdf', 'sort']

  def index
    @story_points = 0
    @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
    render :action => 'get_started' if @account.user_stories.blank?
    prawnto :filename => 'backlog.pdf', :inline => false
  end
  
  def export
    stream_csv do |csv|
      csv << ["ID",
        "Definition",
        "Description",
        "Story points",
        "Acceptance Criteria",
        "Position",
        "Created at",
        "Last modified"]
      @user_stories.each do |a|
        csv << [a.id,
          a.definition,
          a.description,
          a.story_points,
          a.acceptance_criteria.map(&:detail).join(";").gsub('"', "'"),
          a.position,
          a.created_at.strftime('%d/%m/%y %T'),
          a.updated_at.strftime('%d/%m/%y %T')]
      end
    end
  end
  
  def feed
    render :layout => false
  end
  
  def pdf
    @rails_pdf_name = "Backlog.pdf"
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
end