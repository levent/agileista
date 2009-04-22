class UserStoriesController < AbstractSecurityController
  before_filter :must_be_team_member, :except => [:add, :create_via_add, :show, :plan, :unplan, :reorder]
  before_filter :user_story_must_exist, :only => ['update', 'add_to_sprint', 'remove_from_sprint', 'show', 'create_acceptance_criterium',
    :edit, :move_up, :move_down, :delete, :destroy, :delete_acceptance_criterium, :done, :unfinished, :copy, :plan, :unplan]
  
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
  end
  
  def add
  end
  
  def show
  end
  
  def create
    @tags = params[:tags]
    @themes = params[:themes] || ""
    @user_story = UserStory.new(params[:user_story])
    @user_story.account = @account
    @user_story.person = current_user
    if @user_story.save
      @user_story.tag_with(params[:tags])
      @user_story.theme_with(params[:themes])
      
      if params[:commit] == "Add at start of backlog"
        @user_story.move_to_top
      else
        @user_story.move_to_bottom
      end
      
      flash[:notice] = "User story created successfully"
      redirect_to :controller => 'user_stories', :action => 'edit', :id => @user_story
      
    else
      flash[:error] = "There were errors creating the user story"
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
  
  # def create_acceptance_criterium
  #   if request.post? or request.xhr?
  #     @task = Task.new
  #     @acceptance_criterium = AcceptanceCriterium.new(params[:acceptance_criterium])
  #     @acceptance_criterium.user_story = @user_story
  #     if @acceptance_criterium.save
  #       flash[:notice] = "Criterium created successfully"
  #       redirect_to :action => "edit", :id => @user_story, :sprint_id => params[:sprint_id] unless request.xhr?
  #       render :partial => 'acceptance_criteria' if request.xhr?
  #     else
  #       flash[:error] = "There were errors adding criteria"
  #       render :controller => 'user_stories', :action => 'edit', :id => @user_story, :sprint_id => params[:sprint_id] unless request.xhr?
  #       render :partial => 'acceptance_criteria' if request.xhr?
  #     end
  #   end
  # end
  
  # def delete_acceptance_criterium
  #   if request.xhr? or request.post?
  #     @acceptance_criterium = @user_story.acceptance_criteria.find(params[:crit_id])
  #     if @acceptance_criterium.destroy
  #       render :partial => 'user_stories/acceptance_criteria' if request.xhr?
  #     end
  #   end
  # end
  
  def edit
    @tags = @user_story.tags.map(&:name).join(' ')
    @task = Task.new
    @acceptance_criterium = AcceptanceCriterium.new
  end
  
  def update
    @tags = params[:tags]
    @themes = params[:themes] || ""
    if @user_story.update_attributes(params[:user_story])
      @user_story.tag_with(@tags)
      @user_story.theme_with(@themes)
      flash[:notice] = "User story updated successfully"
    else
      flash[:error] = "User story couldn't be updated"
      @acceptance_criterium = AcceptanceCriterium.new
      render :action => 'edit' and return false
    end
    if params[:sprint_id]
      redirect_to sprint_path(:id => params[:sprint_id])
    elsif params[:from] && params[:from] == 'themes'
      redirect_to :controller => 'themes'
    elsif params[:from] && params[:from] == 'show'
      redirect_to :action => 'show', :id => @user_story
    else
      redirect_to :controller => 'backlog'
    end
  end
  
  def plan
    sprint = @account.sprints.find(params[:sprint_id])
    @user_story.sprint = sprint
    @user_story.save
    SprintElement.find_or_create_by_sprint_id_and_user_story_id(sprint.id, @user_story.id)
    render :json => {:ok => true}.to_json
  end
  
  def unplan
    sprint = @account.sprints.find(params[:sprint_id])
    @user_story.sprint = nil
    @user_story.save
    SprintElement.destroy_all("sprint_id = #{sprint.id} AND user_story_id = #{@user_story.id}")
    render :json => {:ok => true}.to_json
  end
  
  def reorder
    sprint = @account.sprints.find(params[:sprint_id])
    split_by = "&com[]="
    items = params[:user_stories].split(split_by)
    items[0] = items[0].gsub('com[]=', '')
    sprint.sprint_elements.each do |se|
      se.position = items.index(se.user_story_id.to_s) + 1
      se.save
    end
    render :json => {:ok => true}.to_json
  end
  
  def remove_from_sprint
    @user_story.sprint = nil
    @sprint = Sprint.find(params[:sprint_id])
    SprintElement.find(:all, :conditions => ["sprint_id = ? AND user_story_id = ?", @sprint.id, @user_story.id]).collect{|se| se.destroy}
    if @user_story.save
      flash[:notice] = "User story removed from sprint"
    else
      flash[:error] = "User story couldn't be removed"
      render :action => 'edit'
    end
    redirect_to sprint_path(:id => params[:sprint_id])
  end
  
  def destroy
    if @user_story.destroy
      flash[:notice] = "User story deleted"
    end
    redirect_to themes_path and return false if params[:from] == 'themes'
    redirect_to :controller => 'backlog' and return false
  end
end