class SignupController < ApplicationController
  ssl_required :index, :ok, :create, :validate

  def index
    redirect_to :controller => 'backlog', :subdomain => Account.find(session[:account]).name and return false if logged_in?
    @account = Account.new
  end
  
  def create
    redirect_to :controller => 'signup', :action => 'index' and return false if reserved_account_name?(params[:account])
    @account = Account.new(params[:account])
    @user = @account.team_members.new(params[:user])
    @account.account_holder = @user
    # @user.account = @account
    if @account.valid? && @user.valid? && @account.save # only save if valid!
      # @account.save
      @user.account = @account
      @user.save
      @account.save
      NotificationMailer.deliver_account_activation_info(@user, @account, self) 
      flash[:notice] = "Account created.. please check your email to validate your account"
      redirect_to :action => 'ok', :subdomain => @account.name
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