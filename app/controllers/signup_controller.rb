class SignupController < ApplicationController
  ssl_required :index, :ok, :create, :validate

  def index
    redirect_to :controller => 'backlog', :account_name => Account.find(session[:account]).name and return false if logged_in?
    @account = Account.new
  end
  
  def create
    # @user = TeamMember.new(params[:user])
    @account = Account.new(params[:account])
    @user = @account.team_members.new(params[:user])
    @account.account_holder = @user
    # @user.account = @account
    if @account.valid? && @account.save
      # @account.save
      @user.account = @account
      @user.save
      @account.save
      NotificationMailer.deliver_account_activation_info(@user, @account, self) 
      flash[:notice] = "Account created.. please check your email to validate your account"
      redirect_to :action => 'ok', :account_name => params[:account_name]
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
      redirect_to :controller => "login", :action => "index", :account_name => params[:account_name]
    end
  end
  
end
