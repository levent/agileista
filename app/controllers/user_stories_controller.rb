class UserStoriesController < AbstractSecurityController
  ssl_allowed
  before_filter :must_be_team_member, :except => [:add, :create_via_add, :show, :plan, :unplan, :reorder]
  before_filter :user_story_must_exist, :only => ['update', 'show',
    :edit, :delete, :destroy, :done, :copy, :plan, :unplan]
  before_filter :set_sprint, :only => [:new, :show, :edit, :create, :plan, :unplan, :reorder]
  before_filter :set_additional_themes, :only => [:create, :update]
  
  def copy
    if @user_story.copy
      flash[:notice] = "User story copied and added to backlog"
    else
      flash[:error] = "The user story could not be copied"
    end
    redirect_to :back
  end
  
  def new
    @user_story = UserStory.new
    @user_story.acceptance_criteria.build
    @user_story.tasks.build
  end
  
  def add
  end
  
  def show
    store_location
    redirect_to sprint_user_story_url(@user_story.sprint_id, @user_story) if @user_story.sprint && !params[:sprint_id]
  end
  
  def create
    @user_story = UserStory.new(params[:user_story])
    @user_story.account = @account
    @user_story.person = current_user
    @user_story.sprint = @sprint
    if @user_story.save
      @account.tag(@user_story, :with => params[:tags], :on => :tags)
      assign_additional_themes
      
      if params[:commit] == "Add at start of backlog"
        @user_story.move_to_top
      else
        @user_story.move_to_bottom
      end
      
      if params[:commit] == "Add to task board"
        SprintElement.find_or_create_by_sprint_id_and_user_story_id(@sprint.id, @user_story.id)
        flash[:notice] = "User story added successfully"
        redirect_to sprint_url(@sprint)
      else
        flash[:notice] = "User story created successfully"
        redirect_to backlog_index_path
      end
    else
      flash[:error] = "There were errors creating the user story"
      @user_story.acceptance_criteria.build
      @user_story.tasks.build
      render :action => 'new'
    end
  end

  def create_via_add
    @user_story = UserStory.new
    @user_story.definition = params[:user_story][:definition]
    @user_story.description = params[:user_story][:description]
    @user_story.account = @account
    @user_story.person = current_user
    if @user_story.save
      flash[:notice] = "User story created successfully"
      redirect_to :controller => 'backlog'
    else
      flash[:error] = "There were errors creating the user story"
      render :action => 'add'
    end
  end
  
  def edit
    @tags = @user_story.tags.map(&:name).join(' ')
    @user_story.acceptance_criteria.build
    @user_story.tasks.build
  end
  
  def update
    if @user_story.update_attributes(params[:user_story])
      @account.tag(@user_story, :with => params[:tags], :on => :tags)
      assign_additional_themes
      flash[:notice] = "User story updated successfully"
    else
      flash[:error] = "User story couldn't be updated"
      @user_story.acceptance_criteria.build
      @user_story.tasks.build
      render :action => 'edit' and return false
    end
    redirect_back_or(backlog_index_url)
  end
  
  def plan
    @user_story.sprint = @sprint
    @user_story.save
    SprintElement.find_or_create_by_sprint_id_and_user_story_id(@sprint.id, @user_story.id)
    render :json => {:ok => true}.to_json
  end
  
  def unplan
    @user_story.sprint = nil
    @user_story.save
    SprintElement.destroy_all("sprint_id = #{@sprint.id} AND user_story_id = #{@user_story.id}")
    respond_to do |format|
      format.html {
        flash[:notice] = "User story removed from sprint"
        redirect_to sprint_path(@sprint)
      }
      format.json {render :json => {:ok => true}.to_json}
    end
  end
  
  def reorder
    split_by = "&item[]="
    items = params[:user_stories].split(split_by)
    items[0] = items[0].gsub('item[]=', '')
    @sprint.sprint_elements.each do |se|
      se.position = items.index(se.user_story_id.to_s) + 1
      se.save
    end
    render :json => {:ok => true}.to_json
  end
  
  def destroy
    if @user_story.destroy
      flash[:notice] = "User story deleted"
    end
    redirect_back_or(backlog_index_url)
  end
  
  protected
  
  def set_sprint
    @sprint ||= @account.sprints.find(params[:sprint_id]) if params[:sprint_id]
  end
  
  def set_additional_themes
    unless params[:additional_theme].blank?
      @additional_theme = @account.themes.find_or_create_by_name(params[:additional_theme])
    end
  end
  
  def assign_additional_themes
    @user_story.themes << @additional_theme if @additional_theme
  end
end
