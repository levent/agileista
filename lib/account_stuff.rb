module AccountStuff
  AccountStuff::RESERVED_SUBDOMAINS = %w(app www site we blog dev stage)
  AccountStuff::TEAM_AGILEISTA = ["lebreeze@gmail.com", "ebstar@gmail.com"]
  if Rails.env == "staging"
    AccountStuff::MASTER_SUBDOMAIN = "www"
    AccountStuff::DOMAIN = "featurecloud.com"
    AccountStuff::SIGNUP_SITE = "#{AccountStuff::MASTER_SUBDOMAIN}.#{AccountStuff::DOMAIN}"
  else
    AccountStuff::MASTER_SUBDOMAIN = "app"
    AccountStuff::DOMAIN = "agileista.com"
    AccountStuff::SIGNUP_SITE = "#{AccountStuff::MASTER_SUBDOMAIN}.#{AccountStuff::DOMAIN}"
  end
  
  protected
  
  def current_user
    begin
      current_user = (session[:user] && session[:account]) ? Person.find_by_id_and_account_id(session[:user], session[:account]) : nil
    rescue
      session[:user] = nil
      session[:account] = nil
      session[:timeout] = nil
      current_user = nil
    end
  end
  
  def do_logout
    session[:user] = nil
    session[:account] = nil
    session[:timeout] = nil
  end
    
  def logged_in?
    current_user.nil? ? false : true
  end
  
  # adds ActionView helper methods
  def self.included(base)
    base.send :helper_method, :logged_in?, :current_user
  end
end
