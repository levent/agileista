class AbstractSecurityController < ApplicationController
  cache_sweeper :sprint_audit_sweeper
  before_filter :must_be_logged_in
  
  private
  
  def must_be_logged_in
    case request.format
    when Mime::XML, Mime::ATOM
      if logged_in?
        setup_account_variables
        return true
      else
        @account = Account.find_by_subdomain(current_subdomain)
        if user = authenticate_with_http_basic { |u, p| @account.authenticate(u, p) }
          current_user = user
        else
          request_http_basic_authentication
        end
      end
    else
      if logged_in?
        setup_account_variables
        return true
      else
        flash[:error] = 'Please log in'
        redirect_to :controller => '/login' and return false
      end
    end
  end

  def setup_account_variables
    @account = current_user.account
    @other_accounts = Person.find_all_by_email_and_authenticated(current_user.email, 1)
  end

  def redirect_back_or(default)
    redirect_to(return_to || default)
    clear_return_to
  end

  def store_location
    if request.get?

      session[:return_to] = request.url
      session[:return_to] = "/backlog" if session[:return_to] == "/backlog.atom"
    end
  end
  
  def return_to
    session[:return_to] || params[:return_to]
  end
  
  def clear_return_to
    session[:return_to] = nil
  end
  
end
