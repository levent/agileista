class ThemesController < ApplicationController

  before_filter :must_be_logged_in
  before_filter :must_be_team_member, :except => [:index]

  def index
    @themes = @account.themes.find(:all, :order => 'themes.name, user_stories.position', :include => [:user_stories])
  end
  
  def new
    @theme = Theme.new
    @theme.account = @account
  end
  
  def create
    @theme = Theme.new(params[:theme])
    @theme.account = @account
    if @theme.save
      flash[:notice] = "Theme saved successfully"
      redirect_to :action => 'index'
    else
      flash[:error] = "There were issues saving the theme"
      render :action => 'new'
    end
  end
  
  def edit
    @theme = @account.themes.find(params[:id])
  end
  
  def update
    @theme = @account.themes.find(params[:id])
    @theme.account = @account
    if @theme.update_attributes(params[:theme])
      flash[:notice] = "Theme saved successfully"
      redirect_to :action => 'index'
    else
      flash[:error] = "There were issues saving the theme"
      render :action => 'edit', :id => params[:id]
    end
  end
  
end
