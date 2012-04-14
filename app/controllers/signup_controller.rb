class SignupController < ApplicationController
#  ssl_required :index, :ok, :create, :validate

  def index
    logger.error("/signup#{AccountStuff::MASTER_SUBDOMAIN}")
    logger.error("/signup#{current_subdomain}")
    if logged_in?
      redirect_to :controller => 'backlog', :subdomain => current_subdomain and return false
    elsif AccountStuff::MASTER_SUBDOMAIN != current_subdomain
      redirect_to login_path(:subdomain => current_subdomain)
    end
    @account = Account.new
    @user = @account.team_members.new
  end
  
  def create
    redirect_to :controller => 'signup', :action => 'index' and return false if reserved_subdomain?(params[:account])
    @account = Account.new(params[:account])
    @user = @account.team_members.new(params[:user])
    @account.account_holder = @user
    if @account.valid? && @user.valid? && @account.save # only save if valid!
      @user.account = @account
      @user.save
      @account.save
      NotificationMailer.account_activation_info(@user, @account).deliver
      NotificationMailer.new_account_on_agileista(@account).deliver
      flash[:notice] = "Account created.. please check your email to validate your account"
      redirect_to :action => 'ok', :subdomain => @account.subdomain
    else
      # flash[:error] = "Oh oh!"
      render :action => 'index'
    end    
  end
  
  def ok
  end
  
  def validate
    @user = Person.find_by_activation_code(params[:id])
    redirect_to :action => "index" and return false if @user.nil?
    if @user.validate_account
      flash[:notice] = "Your account has been validated<br />Please login below"
      redirect_to :controller => "login", :action => "index", :subdomain => current_subdomain
    end
  end
  
  protected
  
  def reserved_subdomain?(account_params)
    if account_params[:subdomain] && AccountStuff::RESERVED_SUBDOMAINS.include?(account_params[:subdomain])
      return true
    else
      return false
    end
  end
end
