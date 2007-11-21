module AccountStuff
  protected
  
  def do_logout
    session[:user] = nil
    session[:account] = nil
  end
    
  def logged_in?
    unless Person.find_by_id_and_account_id(session[:user], session[:account]).nil?
      return true
    end
  end
  
  # adds ActionView helper methods
  def self.included(base)
    base.send :helper_method, :logged_in?
  end
end
