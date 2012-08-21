class ThemesController < AbstractSecurityController

  def index
    store_location
    @themes = @account.themes.find(:all, :order => 'themes.position, user_stories.position', :include => [:user_stories])
  end
  
  def new
    @theme = @account.themes.new
    @theme.account = @account
  end
  
  def create
    @theme = @account.themes.new(params[:theme])
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
  
  def destroy
    @theme = @account.themes.find(params[:id])
    if @theme.destroy
      flash[:notice] = "Theme deleted"
    else
      flash[:error] = "Theme couldn't be deleted"
    end
    redirect_to themes_path
  end
  
  def sort
    raise "TODO"
    @themes = @account.themes.find(:all, :order => 'themes.position, user_stories.position', :include => [:user_stories])
    if @themes.any?
      split_by = "&theme[]="
      items = params[:themes].split(split_by)
      items[0] = items[0].gsub('theme[]=', '')
      @themes.each do |theme|
        theme.position = items.index(theme.id.to_s) + 1
        theme.save
      end
    end
    render :json => {:ok => true}.to_json
  end  
end
