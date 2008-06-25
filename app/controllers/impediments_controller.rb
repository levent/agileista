class ImpedimentsController < AbstractSecurityController
  
  def index
    @impediments = @account.impediments
  end
end
