# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AccountStuff
  include AccountLocation
  include SslRequirement
  
  require_dependency 'tag'
  require_dependency 'tagging'

  protected
  
  def ssl_required?
    return false if local_request? || RAILS_ENV == 'test'
    super
  end

  def must_be_logged_in
    # @current_user ||= Person.find_by_id_and_account_id(session[:user], session[:account])
    if logged_in?
      # @account ||= Account.find(session[:account])
      @account ||= @current_user.account
      @other_account_people = Person.find_all_by_email_and_authenticated(@current_user.email,1) - [@current_user]
      return true
    else
      flash[:error] = 'Please log in'
      redirect_to :controller => '/login' and return false
    end
  end
    
  def user_story_must_exist
    begin
      @user_story = @account.user_stories.find(params[:id])
    rescue
      return false
    end
    if @user_story && @user_story.class == UserStory
      return true
    else
      redirect_to :controller => '/backlog' and return false
    end
  end
  
  def sprint_must_exist
    begin
      @sprint = @account.sprints.find(params[:id])
    rescue
      flash[:error] = "No such sprint"
      redirect_to :controller => 'sprint_planning' and return false
    end
  end
  
  def must_be_team_member
    current_user.is_a?(TeamMember) ? true : (redirect_to :controller => 'backlog' and return false)
  end
  
  def must_be_account_holder
    current_user.account_holder? ? true : (redirect_to :controller => 'backlog' and return false)
  end
  
  # excludes DONE
  def account_user_stories
     @user_stories = @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil])
  end
  
  # please see notes in user_story method
  #  this needs to be refactored to exclude sprint_id
  def estimated_account_user_stories
    @user_stories = @account.user_stories.find(:all, :conditions => ['done = ? AND sprint_id IS ? AND story_points IS NOT ?', 0, nil, nil])
  end
  
  def unplanned_estimated_user_stories
    @user_stories = @account.user_stories.find(:all, :conditions => ['done = ? AND story_points IS NOT ?', 0, nil], :order => 'position')
  end
  
  def calculate_dayzero(sprint_id)
    @sprint = Sprint.find(sprint_id)
    return false if @sprint.start_at <= Time.now
    @burndown = Burndown.find_or_create_by_sprint_id_and_created_on(@sprint.id, @sprint.start_at.to_date)
    @burndown.hours_left = @sprint.hours_left
    @burndown.save
  end

  def calculate_todays_burndown
    @burndown = Burndown.find_or_create_by_sprint_id_and_created_on(@current_sprint.id, Date.today)
    @burndown.hours_left = @current_sprint.hours_left
    @burndown.save
  end
  
  def calculate_tomorrows_burndown
    @burndown = Burndown.find_or_create_by_sprint_id_and_created_on(@current_sprint.id, Date.tomorrow)
    @burndown.hours_left = @current_sprint.hours_left
    @burndown.save
  end
  
  def create_chart
    chartdata = "<chart caption='Burndown' xAxisName='Day' yAxisName='Hours left' showValues='1' formatNumberScale='0' showBorder='1'>"
    index = 0
    day = 0
    done = false
    for i in @current_sprint.start_at.to_date..@current_sprint.end_at.to_date
      x = @current_sprint.burndowns.find(:first, :conditions => ["created_on = ?", i])
      y = x.hours_left if x
      if y && (i.to_date <= Date.today)
        chartdata += "<set label='#{day}' value='#{y}' toolText='#{y} hours remaining beginning of #{i.to_date}' />"
      else
        if done || (i.to_date != Date.tomorrow)
          chartdata += "<set label='#{day}' value='' />"
        else
          chartdata += "<set label='#{day}' value='#{@current_sprint.hours_left}' anchorBorderColor='#ff0000' toolText='Current hours left' />"
          done = true
        end
      end
      index += 1
      day += 1
    end
    chartdata += "</chart>"
    @chart = renderChartHTML("/FusionCharts/Line.swf", "", chartdata, "myFirst", '96%', 250, false)
  end

  ######### REPORTS
  #
  #
  
  def boolToNum(bVal)
    if bVal==true
      intNum = 1
    else
      intNum = 0
    end
    boolToNum = intNum
  end


  def renderChartHTML(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode)
    #Generate the FlashVars string based on whether dataURL has been provided or dataXML.
    strFlashVars=''
    if strXML==""
      #DataURL Mode
      strFlashVars = "&chartWidth="+ chartWidth.to_s+ "&chartHeight=" + chartHeight.to_s + "&debugMode=" + boolToNum(debugMode).to_s + "&dataURL=" + strURL
    else
      #DataXML Mode
      strFlashVars = "&chartWidth=" + chartWidth.to_s + "&chartHeight=" +chartHeight.to_s + "&debugMode=" + boolToNum(debugMode).to_s + "&dataXML=" + strXML 		
    end
  	renderChartText='<!-- START Code Block for Chart ' + chartId +' -->' + " \n "
    renderChartText=renderChartText+'<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="'+ chartWidth.to_s + '" height="' + chartHeight.to_s + '" id="' + chartId + '">' + " \n "
    renderChartText=renderChartText+ "\t" + '<param name="allowScriptAccess" value="always" />' + " \n "
		renderChartText=renderChartText+ "\t" + '<param name="movie" value="'+chartSWF+'"/>' + " \n "
		renderChartText=renderChartText+ "\t" + '<param name="FlashVars" value="'+strFlashVars+'" />' + " \n "
		renderChartText=renderChartText+ "\t" + '<param name="quality" value="high" />' + " \n "
		renderChartText=renderChartText+ "\t" + '<embed src="'+chartSWF+'" FlashVars="' + strFlashVars + '" quality="high" width="' + chartWidth.to_s +  '" height="'+chartHeight.to_s + '" name="' + chartId + '" allowScriptAccess="always" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />' + " \n "
    renderChartText=renderChartText+ '</object>' + " \n "
    renderChartText=renderChartText+'<!-- END Code Block for Chart ' + chartId +' -->'
    renderChartHTML=renderChartText
  end
  ######

end
