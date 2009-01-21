class NotificationMailer < ActionMailer::Base
  include SubdomainFu::Controller
  include ActionController::UrlWriter
  
  def account_activation_info(user, account, controller)
    @recipients  = "#{user.email}"
    @from        = EMAIL_FROM
    @sent_on     = Time.now
    @body[:url]  = controller.url_for :controller => 'signup', :action => 'validate', :id => user.activation_code, :subdomain => account.subdomain
    @body[:user] = user
    @subject     = "Welcome to Agileista!"
  end
  
  def account_invitation(user, account, controller, password = nil)
    @recipients  = "#{user.email}"
    @from        = EMAIL_FROM
    @sent_on     = Time.now
    @body[:url]  = controller.url_for :controller => 'signup', :action => 'validate', :id => user.activation_code, :subdomain => account.subdomain
    @body[:user] = user
    @body[:pass] = password
    @body[:sender] = account.account_holder
    @body[:account] = account
    @subject     = "Welcome to Agileista!"
  end
  
  def password_reminder(user, account, controller, password = nil)
    @recipients  = "#{user.email}"
    @from        = EMAIL_FROM
    @sent_on     = Time.now
    @body[:url]  = controller.url_for :controller => 'login', :subdomain => account.subdomain
    @body[:user] = user
    @body[:pass] = password
    @body[:account] = account
    @subject     = "Hey Agileista! Here is your password reminder"
  end
  
  def account_information(user, account)
    @recipients       ="#{user.email}"
    @from             = EMAIL_FROM
    @sent_on          = Time.now
    @body[:url]       = url_for :controller => 'login', :subdomain => account.subdomain, :host => 'app.agileista.com'
    @body[:user]      = user
    @body[:account]   = account
    @subject          = "Hey Agileista! Here's some important information on accessing your account"
  end
  
  # INTERNAL MAILS
  def new_account_on_agileista(account)
    if Rails.env == "development"
      @recipients = "lebreeze@gmail.com"
    else
      @recipients = AccountStuff::TEAM_AGILEISTA
    end
    @subject = "[AGILEISTA ADMIN] There has been a new account registration"
    @sent_on  = Time.now
    @body[:account] = account
  end
end