module AccountStuff
  AccountStuff::RESERVED_SUBDOMAINS = %w(app www site we blog dev stage)
  AccountStuff::MASTER_SUBDOMAIN = "app"
  
  protected
  
  def current_user
    begin
      @current_user ||= (session[:user] && session[:account]) ? Person.find_by_id_and_account_id(session[:user], session[:account]) : nil
    rescue
      session[:user] = nil
      session[:account] = nil
      session[:timeout] = nil
      @current_user = nil
    end
  end
  
  def do_logout
    session[:user] = nil
    session[:account] = nil
    session[:timeout] = nil
  end
    
  def logged_in?
    unless current_user.nil?
      return true
    end
  end
  
  # adds ActionView helper methods
  def self.included(base)
    base.send :helper_method, :logged_in?, :current_user
  end
end
