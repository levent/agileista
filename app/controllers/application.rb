# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AccountStuff
  include AccountLocation
  
  # require_dependency 'user_story'
  require_dependency 'tag'
  require_dependency 'tagging'
  # include SslRequirement

  protected

  def must_be_logged_in
    # @current_user ||= Person.find_by_id_and_account_id(session[:user], session[:account])
    if logged_in?
      @account ||= Account.find(session[:account])
      return true
    else
      flash[:error] = 'Please log in'
      redirect_to :controller => '/login' and return false
    end
  end
  
  def project_must_exist
    begin
      @project = Project.find(:first, :conditions => ["id = ? AND account_id = ?", params[:id], @account.id])
    rescue
      return false
    end
    if @project && @project.class == Project
      return true
    else
      redirect_to :controller => '/projects' and return false
    end
  end
  
  def user_story_must_exist
    begin
      @user_story = UserStory.find(params[:user_story])
    rescue
      return false
    end
    if @user_story && @user_story.class == UserStory
      return true
    else
      redirect_to :controller => '/projects' and return false
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
  
  def estimated_account_user_stories
    @user_stories = @account.user_stories.find(:all, :conditions => ['done = ? AND sprint_id IS ? AND story_points IS NOT ?', 0, nil, nil])
  end
  
  def unplanned_estimated_user_stories
    @user_stories = @account.user_stories.find(:all, :conditions => ['done = ? AND story_points IS NOT ?', 0, nil], :order => 'position')
  end
  
  def calculate_todays_burndown
    @burndown = Burndown.find_or_create_by_sprint_id_and_created_on(@current_sprint.id, Date.today)
    @burndown.hours_left = @current_sprint.hours_left
    @burndown.save
  end
  
  def create_chart
 
    # calculate_linear_regression(@burndowns.map(&:hours_left))
    chartdata = "<chart caption='Burndown' xAxisName='Date' yAxisName='Hours left' showValues='1' formatNumberScale='0' showBorder='1'>"
    index = 0
    points = []
    day = 1
    done = false
    for i in @current_sprint.start_at.to_date..@current_sprint.end_at.to_date
      x = @current_sprint.burndowns.find(:first, :conditions => ["created_on = ?", i])
      y = x.hours_left if x
      
      if y && (i.to_date <= Date.today)
        points << [index, y]
        chartdata += "<set label='#{day}' value='#{y}' />"
      else
        chartdata += "<set label='#{day}' value='#{@current_sprint.hours_left}' />" unless done
        chartdata += "<set label='#{day}' value='' />" if done
        done = true
      end
      index += 1
      day += 1
    end
    
    if y > @current_sprint.hours_left

    end
    # points = points[0..7]
    # linear, x = calculate_linear_regression(points)
    # chartdata += "<trendLines><line startValue='#{linear[0][1]}' endValue='#{linear.last[1]}' color='FF0000' /></trendLines>"
    chartdata += "</chart>"
    @chart = renderChartHTML("/FusionCharts/Line.swf", "", chartdata, "myFirst", 800, 300, false)
    # @demo = line
    
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
