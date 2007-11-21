class BacklogController < ApplicationController

  before_filter :must_be_logged_in
  before_filter :must_be_team_member, :only => ['sort_release', 'sort_unassigned']
  before_filter :account_user_stories ,:only => ['index', 'sort_release', 'sort_unassigned']

  def index
    params[:order] ? order = 'story_points DESC' : order = 'position'
    @user_stories = @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil], :order => order)
    @story_points = 0
    @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
    @cloud = Tag.cloud(:conditions => ["tags.account_id = ?", @account.id])
  end
  
  def feed
    @user_stories = @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil], :order => 'position')
    render :layout => false
  end
  
  def pdf
    @rails_pdf_name = "Backlog.pdf"
    # @content = "This is dynamic content!!!"
    @user_stories = @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil], :order => 'position')
    render :layout => false
  end
  
  def search
    index
    if request.post? && params[:q]
      @user_stories = @account.user_stories.find_by_contents("active:yes #{params[:q]}", :limit => :all)
      @story_points = 0
      @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
    else
      flash[:notice] = "No user stories found"
      redirect_to :action => 'index'
    end
  end
  
  def search_tags
    index
    if request.post? && tagged_account_user_stories(params[:tag])
      @user_stories = @account.user_stories.find_by_contents("active:yes tag_string:#{params[:tag]}", :limit => :all)
      # @user_stories = Tag.find_by_name(params[:tag].to_s).taggables & @account.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil])
      @story_points = 0
      @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
      render :action => 'search'
    else
      flash[:notice] = "No user stories found"
      redirect_to :action => 'index'
    end    
  end

  def sprint
    @current_sprint = @account.sprints.find(:first, :conditions => ["start_at < ? AND end_at > ?", Time.now, 1.days.ago])
    @upcoming_sprints = @account.sprints.find(:all, :conditions => ["start_at > ?", Time.now])
  end

  def sort_release
    @user_stories.each do |story| 
      story.position = params['userstorylist'].index(story.id.to_s) + 1 
      story.save 
    end 
    render :nothing => true 
  end
  
  def sort_unassigned
    @user_stories.each do |story| 
      story.position = params['userstorylist'].index(story.id.to_s) + 1 
      story.save 
    end 
    render :nothing => true 
  end
  
  def sort_sprint
    @user_stories = @account.sprints.find(params[:sprint_id]).user_stories
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

end