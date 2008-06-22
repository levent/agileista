class SprintController < AbstractSecurityController

  before_filter :must_be_logged_in
  before_filter :must_be_team_member, :except => [:index]
  # before_filter :sprint_must_exist, :only => [:show]
  
  def index
    redirect_to :controller => 'account', :action => 'settings' and flash[:notice] = "Please specify an iteration length first" and return false if @account.iteration_length.blank?
    @current_sprint = @account.sprints.find(:first, :conditions => ["start_at < ? AND end_at > ?", Time.now, 1.days.ago])
    if @current_sprint.blank?
      redirect_to :controller => 'backlog' and flash[:notice] = "There is no active sprint" and return false
    end
    calculate_tomorrows_burndown
  
   
     @burndowns = Burndown.find(:all, :conditions => ["sprint_id = ?", @current_sprint.id], :order => :created_on)
     # @assigned_user_stories = @account.user_stories - @unassigned_user_stories
     # @elements = @current_sprint.sprint_elements.find(:all, :include => [:user_story])
     @user_stories = @current_sprint.user_stories#.find(:all, :order => :position)
     @incomplete = []
     @inprogress = []
     @complete = []
     for us in @user_stories
       for task in us.tasks.find(:all, :order => :position)
         @complete << task if task.complete?
         @inprogress << task if task.inprogress?
         @incomplete << task if task.incomplete?
       end
     end
   
    create_chart
  end
  
  def update_hours
    @task = Task.find(params[:id])
    @task.hours = params[:task_hours].to_i if @task.developer == Person.find(session[:user])
    if @task.save
      flash[:notice] = "Task hours updated successfully"
    end
    redirect_to :back
  end
  
  def hide_tasks
    @element = SprintElement.find(params[:id])
  end
  
  def move_task
    if request.xhr?
      if params['inprogress'] && !params['inprogress'].blank?
        for item in params['inprogress']
        # for task in Task.find(:all, :conditions => ["id IN (?)", params['inprogress']])
          task = Task.find(item)
          task.developer = @current_user unless task.developer
          task.save
        end
      end
      if params['incomplete'] && !params['incomplete'].blank?
        for item in params['incomplete']
          task = Task.find(item)
          task.developer = nil
          task.save
        end
      end
      if params['complete'] && !params['complete'].blank?
        for item in params['complete']
          task = Task.find(item)
          task.hours = 0
          task.save
        end
      end
    end
    # logger.info params.inspect
    render :nothing => true
  end

  private
  
  def calculate_linear_regression(points)
    n = points.length
    ey = 0
    ex = 0
    exy = 0
    ex2 = 0
    ey2 = 0
    
    ex22 = 0
    ey22 = 0
    points.each {|x| 
      ey += x[1]# and
      ex += x[0]
      exy += (x[0]*x[1])
      ex2 += (x[0]*x[0])
      ey2 += (x[1]*x[1])
    }
    ex22 = ex2*ex2
    ey22 = ey2*ey2
    
    m = ((n*exy).to_f-(ex*ey).to_f).to_f/(n*ex2-ex22).to_f
    b = (ey-m*ex).to_f/n
    r = (n*exy-ex*ey).to_f/Math.sqrt((n*ex2-ex22)*(n*ey2-ey22))

    # {|x| }
    # ex = 0
    # points.each {|x| ex += x}

    # points.each {}
    linear = []
    for point in points
      linear << [point[0], (m*point[1] + b)]
    end
    return linear, [linear]
  end
  
end
