class BetaEmailsController < ApplicationController
  
  def index
    new
    render :action => 'new'
  end
  
  def new
  end
  
  def create
    @beta_email = BetaEmail.new(params[:beta_email])
    @beta_email.save
    redirect_to new_beta_email_path
  end
end
