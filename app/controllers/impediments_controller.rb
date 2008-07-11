class ImpedimentsController < AbstractSecurityController
  
  def index
    @impediments = @account.impediments
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
      flash[:error] = 'Impedment could not be created'
      render :action => 'new'
    end
  end
end
