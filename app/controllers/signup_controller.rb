class SignupController < ApplicationController
  ssl_required :index, :ok, :create, :validate

  def index
    if logged_in?
      redirect_to :controller => 'backlog', :subdomain => current_subdomain and return false
    elsif SubdomainFu.preferred_mirror != current_subdomain
      redirect_to :controller => 'login', :subdomain => current_subdomain and return false
    end
    @account = Account.new
  end
  
  def create
    redirect_to :controller => 'signup', :action => 'index' and return false if reserved_account_name?(params[:account])
    @account = Account.new(params[:account])
    @user = @account.team_members.new(params[:user])
    @account.account_holder = @user
    if @account.valid? && @user.valid? && @account.save # only save if valid!
      @user.account = @account
      @user.save
      @account.save
      NotificationMailer.deliver_account_activation_info(@user, @account, self) 
      flash[:notice] = "Account created.. please check your email to validate your account"
      redirect_to :action => 'ok', :subdomain => @account.subdomain
    else
      flash[:error] = "Oh oh!"
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
  
  def reserved_account_name?(account_params)
    if account_params[:name] && SubdomainFu.mirrors.include?(account_params[:name])
      return true # and return false if 
    else
      return false
    end
  end
end