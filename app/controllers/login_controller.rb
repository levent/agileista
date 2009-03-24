class LoginController < ApplicationController
  ssl_required :index, :authenticate, :logout
  
  def index
    if AccountStuff::MASTER_SUBDOMAIN == current_subdomain
      redirect_to root_path and return false
    elsif Account.find_by_subdomain(current_subdomain).nil?
      redirect_to root_path(:subdomain => AccountStuff::MASTER_SUBDOMAIN) and return false
    elsif logged_in?
      redirect_to :controller => 'backlog' and return false
    end
  end
  
  def authenticate
    if request.post?
      account = Account.find_by_subdomain(current_subdomain)
      unless account.nil?
        if logged_in?
          person = account.people.find(:first, :conditions => ["email = ? AND authenticated = ?", current_user.email, 1])
        else
          person = account.authenticate(params[:email], params[:password])
        end
        unless person.nil?
          flash[:notice] = "You have logged in successfully"
          session[:user] = person.id
          session[:account] = account.id
          redirect_to :controller => 'backlog', :subdomain => account.subdomain
        else
          # setup_account_name_for_form
          flash[:error] = "Sorry we couldn't find anyone by that email and password in the account \"#{account.name}\""
          render :action => 'index'
        end
      else
        flash[:error] = "Sorry we couldn't find that account"
        # setup_account_name_for_form
        render :action => 'index'
      end
    end
  end
  
  def logout
    do_logout
    flash[:notice] = "You have been logged out successfully"
    redirect_to :action => 'index'
  end
  
  def forgot
    if request.post?
      account = Account.find_by_subdomain(current_subdomain)
      # account ||= Account.find_by_name(account_subdomain)
      @person = account.people.find(:first, :conditions => ["email = ?", params[:email]]) unless account.nil?
      if @person.nil?# || (account.name == 'jgp' && !@person.account_holder?)
        flash[:error] = "We couldn't find a matching user"
      else
        pass = @person.generate_temp_password
        if @person.save && NotificationMailer.deliver_password_reminder(@person, account, self, pass)
          flash[:notice] = "Please check your email for your new password"
          redirect_to :action => 'index' and return false
        end
      end
    end
  end
end