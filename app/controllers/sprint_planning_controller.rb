class SprintPlanningController < AbstractSecurityController

  ssl_allowed :index, :new, :edit, :update, :create, :show, :view, :destroy
  before_filter :must_be_team_member, :except => [:index, :view]
  before_filter :sprint_must_exist, :only => [:show, :view, :edit, :update, :destroy]
  before_filter :estimated_account_user_stories, :only => [:show]
  
  in_place_edit_for :sprint, :name

  def index
    redirect_to :controller => '/account', :action => 'settings' and flash[:notice] = "Please specify an iteration length first" and return false if @account.iteration_length.blank?
    @upcoming_sprint = @account.sprints.find(:first, :conditions => ["start_at > ?", Time.now])
    @current_sprint = @account.sprints.find(:first, :conditions => ["start_at < ? AND end_at > ?", Time.now, 1.days.ago])
  end
  
  def new
    @sprint = Sprint.new
  end
  
  def edit
  end
  
  def update
    if request.post?
      if @sprint.update_attributes(params[:sprint])
        flash[:notice] = "Sprint saved successfully"
        redirect_to :action => 'index'
      else
        flash[:error] = "There were errors saving the sprint"
        render :action => 'edit'
      end
    end
  end
  
  def create
    if request.post?
      @sprint = Sprint.new(params[:sprint])
      @sprint.account = @account
      if @sprint.start_at.blank?
        @sprint.start_at = Date.new(params[:from][:year].to_i, params[:from][:month].to_i, params[:from][:day].to_i).strftime("%Y-%m-%d %H:%M:%S")
      end
      # if @sprint.end_at.blank?
      #   @sprint.end_at = Date.new(params[:to][:year].to_i, params[:to][:month].to_i, params[:to][:day].to_i).strftime("%Y-%m-%d %H:%M:%S")
      # end
      if @sprint.save
        flash[:notice] = "Sprint created successfully"
        redirect_to :controller => "/sprint_planning"
      else
        flash[:error] = "There were errors creating the sprint"
        render :action => 'new'
      end
    end
  end
  
  def show
    view
    render :action => 'view' and return false if @sprint.finished?
  end
  
  def view
    @current_sprint = @sprint
    # calculate_todays_burndown
    create_chart
  end
  
  def destroy
    if request.delete?
      if @sprint.destroy
        flash[:notice] = "Sprint deleted successfully"
      end
    end
    redirect_to :action => 'index'
  end

end
