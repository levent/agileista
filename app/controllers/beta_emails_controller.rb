class BetaEmailsController < ApplicationController
  
  def index
    if logged_in?
      redirect_to :controller => 'backlog', :subdomain => current_subdomain and return false
    elsif AccountStuff::MASTER_SUBDOMAIN != current_subdomain
      redirect_to :controller => 'login', :subdomain => current_subdomain and return false
    else
      new
      render :action => 'new'
    end
  end
  
  def new
    if logged_in?
      redirect_to :controller => 'backlog', :subdomain => current_subdomain and return false
    elsif AccountStuff::MASTER_SUBDOMAIN != current_subdomain
      redirect_to :controller => 'login', :subdomain => current_subdomain and return false
    end
  end
  
  def create
    @beta_email = BetaEmail.new(params[:beta_email])
    @beta_email.save
    redirect_to new_beta_email_path
  end
end
