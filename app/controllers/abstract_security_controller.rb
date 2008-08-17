class AbstractSecurityController < ApplicationController
  
  # before_filter :set_account
  before_filter :must_be_logged_in
  
  private
  
  # def set_account
  #   @account = Account.find_by_name(params[:account_name])
  # end
  
  def must_be_logged_in
    # @current_user ||= Person.find_by_id_and_account_id(session[:user], session[:account])
    case request.format
    when Mime::XML, Mime::ATOM
      if logged_in?
        setup_account_variables
        return true
      else
        @account = Account.find_by_name(get_account_name_from_request)
        if user = authenticate_with_http_basic { |u, p| @account.authenticate(u, p) }
          @current_user = user
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
  
  def get_account_name_from_request
    params[:account_name]
  end
  
  def setup_account_variables
    @account ||= @current_user.account
    @other_account_people = Person.find_all_by_email_and_authenticated(@current_user.email,1) - [@current_user]
  end
end