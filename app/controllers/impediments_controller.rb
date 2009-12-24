class ImpedimentsController < AbstractSecurityController
  
  ssl_allowed :index, :new, :create, :destroy, :resolve
  before_filter :must_be_team_member, :only => [:new, :destroy, :create, :resolve]
  before_filter :count_impediments, :only => [:index, :active, :resolved]
  
  def index
    @impediments = @account.impediments.paginate :page => params[:page]
    respond_to do |format|
      format.html
      format.atom
    end
  end
  
  def active
    @impediments = @account.impediments.unresolved.paginate :page => params[:page]
    respond_to do |format|
      format.html {render :action => 'index'}
      format.atom {render :action => 'index', :format => 'atom'}
    end
  end
  
  def resolved
    @impediments = @account.impediments.resolved.paginate :page => params[:page]
    respond_to do |format|
      format.html {render :action => 'index'}
      format.atom {render :action => 'index', :format => 'atom'}
    end
  end
  
  def new
    @impediment = @account.impediments.new
  end
  
  def create
    @impediment = @account.impediments.new(params[:impediment])
    @impediment.team_member = current_user
    if @impediment.save
      flash[:notice] = 'Impediment created successfully'
      redirect_to :action => 'index'
    else
      flash[:error] = 'Impediment could not be created'
      render :action => 'new'
    end
  end
  
  def destroy
    @impediment = @account.impediments.find(params[:id])
    if @impediment.team_member == current_user
      @impediment.destroy
      flash[:notice] = 'Impediment deleted successfully'
    else
      flash[:error] = 'Impediment can only be deleted by reporter'
    end
    redirect_to :action => 'index'
  end
  
  def resolve
    @impediment = @account.impediments.find(params[:id])
    @impediment.resolve! ? flash[:notice] = 'Impediment resolved' : flash[:error] = 'Impediment could not be resolved'
    redirect_to :action => 'index', :page => params[:page]
  end
  
  
  protected
  
  def count_impediments
    @resolved_count = @account.impediments.resolved.size
    @unresolved_count = @account.impediments.unresolved.size
  end
end