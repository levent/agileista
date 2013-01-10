class NotificationMailer < ActionMailer::Base
  default :from => EMAIL_FROM
  
  def account_activation_info(user, account)
    @url  = url_for :controller => 'signup', :action => 'validate', :id => user.activation_code, :subdomain => account.subdomain, :host => MAIN_HOST
    mail(:to => user.email, :subject => "[Agileista] Here's your activation information")
  end
  
  def account_invitation(user, account, password = nil)
    @recipients  = "#{user.email}"
    @sent_on     = Time.now
    @url  = url_for :controller => 'signup', :action => 'validate', :id => user.activation_code, :subdomain => account.subdomain, :host => MAIN_HOST
    @pass = password
    @sender = account.account_holder
    mail(:to => user.email, :subject => "[Agileista] Get Started!")
  end
  
  def password_reminder(user, account, password = nil)
    @recipients  = "#{user.email}"
    @sent_on     = Time.now
    @url  = url_for :controller => 'login', :subdomain => account.subdomain, :host => MAIN_HOST
    @pass = password
    mail(:to => user.email, :subject => "[Agileista] This should help you login")
  end

  # INTERNAL MAILS
  def new_account_on_agileista(account)
    @recipients = AccountStuff::TEAM_AGILEISTA
    @account = account
    mail(:to => @recipients, :subject => "[AGILEISTA ADMIN] There has been a new account registration")
  end
end
