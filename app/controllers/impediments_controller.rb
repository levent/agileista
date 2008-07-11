class ImpedimentsController < AbstractSecurityController
  
  def index
    @impediments = @account.impediments
  end
  
  def new
    @impediment = @account.impediments.new
  end
end
