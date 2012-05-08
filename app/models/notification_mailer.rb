class NotificationMailer < ActionMailer::Base
  default :from => EMAIL_FROM
  
  def account_activation_info(user, account)
    @url  = url_for :controller => 'signup', :action => 'validate', :id => user.activation_code, :subdomain => account.subdomain, :host => MAIN_HOST
    mail(:to => user.email, :subject => "Welcome to Agileista")
  end
  
  def account_invitation(user, account, password = nil)
    @recipients  = "#{user.email}"
    @sent_on     = Time.now
    @url  = url_for :controller => 'signup', :action => 'validate', :id => user.activation_code, :subdomain => account.subdomain, :host => MAIN_HOST
    @pass = password
    @sender = account.account_holder
    mail(:to => user.email, :subject => "Welcome to Agileista!")
  end
  
  def password_reminder(user, account, password = nil)
    @recipients  = "#{user.email}"
    @sent_on     = Time.now
    @url  = url_for :controller => 'login', :subdomain => account.subdomain, :host => MAIN_HOST
    @pass = password
    mail(:to => user.email, :subject => "Hey Agileista! This should help you login")
  end
  
  def account_information(user, account)
    @recipients       ="#{user.email}"
    @sent_on          = Time.now
    @body[:url]       = url_for :controller => 'login', :subdomain => account.subdomain, :host => AccountStuff::SIGNUP_SITE
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
    @account = account
    mail(:to => @recipients, :subject => "[AGILEISTA ADMIN] There has been a new account registration")
  end
end
