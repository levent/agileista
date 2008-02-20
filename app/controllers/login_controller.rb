class LoginController < ApplicationController
  # ssl_required :index, :authenticate
  
  def index
  end
  
  def authenticate
      account = Account.find_by_name(params[:account_name])
      account ||= Account.find_by_name(account_subdomain)
      unless account.nil?
        person = account.people.find(:first, :conditions => ["email = ? AND password = ? AND authenticated = ?", params[:email], params[:password], 1])
        unless person.nil?
          flash[:notice] = "You have logged in successfully"
          session[:user] = person.id
          session[:account] = account.id
          redirect_to :controller => 'backlog', :account_name => account.name
        else
          flash[:error] = "Sorry we couldn't find anyone by that email and password in the account \"#{account.name}\""
          render :action => 'index'
        end
      else
        flash[:error] = "Sorry we couldn't find that account"
        render :action => 'index'
      end

  end
  
  def logout
    do_logout
    flash[:notice] = "You have been logged out successfully"
    redirect_to :action => 'index'
  end
  
  def forgot
    if request.post?
      account = Account.find_by_name(params[:account_name])
      account ||= Account.find_by_name(account_subdomain)
      @person = account.people.find(:first, :conditions => ["email = ?", params[:email]]) unless account.nil?
      if @person.nil? || account.name == 'jgp'
        flash[:error] = "We couldn't find a matching user"
      else
        @person.generate_password
        if @person.save && NotificationMailer.deliver_password_reminder(@person, account, self)
          flash[:notice] = "Please check your email for your new password"
          redirect_to :action => 'index' and return false
        end
      end
    end
  end
  
end
