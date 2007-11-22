class NotificationMailer < ActionMailer::Base
  
  def account_activation_info(user, account, controller)
    @recipients  = "#{user.email}"
    @from        = "donotreply@agileista.purebreeze.com"
    @sent_on     = Time.now
    @body[:url]  = controller.url_for :controller => 'signup', :action => 'validate', :id => user.activation_code, :account_name => account.name
    @body[:user] = user
    # @body[:account] = account
    @subject     = "Welcome to Agileista!"
  end
  
  def account_invitation(user, account, controller)
    @recipients  = "#{user.email}"
    @from        = "donotreply@agileista.purebreeze.com"
    @sent_on     = Time.now
    @body[:url]  = controller.url_for :controller => 'signup', :action => 'validate', :id => user.activation_code, :account_name => account.name
    @body[:user] = user
    @body[:sender] = account.account_holder
    @body[:account] = account
    @subject     = "Welcome to Agileista!"
  end
  
  def password_reminder(user, account, controller)
    @recipients  = "#{user.email}"
    @from        = "donotreply@agileista.purebreeze.com"
    @sent_on     = Time.now
    @body[:url]  = controller.url_for :controller => 'login', :account_name => account.name
    @body[:user] = user
    @body[:account] = account
    @subject     = "Hey Agileista! Here is your password reminder"
  end
  
end
