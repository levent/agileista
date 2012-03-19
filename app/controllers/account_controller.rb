class AccountController < AbstractSecurityController
#  ssl_required :change_password, :settings
#  ssl_allowed :sort, :resend_authentication, :index
  before_filter :must_be_team_member, :only => [:sort]
  
  def index
    redirect_to :action => 'settings'
  end
  
  def settings
    if request.post?
      if @account.update_attributes(params[:account])
        flash[:notice] = "Settings saved"
        redirect_to :controller => 'backlog' and return false
      else
        flash[:error] = "Settings couldn't be saved"
      end
    end
  end
  
  def change_password
    if request.post?
      @user = current_user
      if @account.authenticate(current_user.email, params[:old_password])
        if @user.update_attributes(:password => params[:new_password], :password_confirmation => params[:new_password_confirmation])
          flash[:notice] = "Password changed successfully"
          redirect_to :action => 'settings' and return false
        else
          render :action => 'settings'
        end
      else
        flash[:error] = "The password you entered didn't match"
        redirect_to :action => 'settings' and return false
      end
    end
  end
  
  def resend_authentication
    if request.post?
      @person = @account.people.find(params[:id])
      pass = @person.generate_temp_password
      if NotificationMailer.account_invitation(@person, @account, pass).deliver
        flash[:notice] = "Reminder sent successfully"
      else
        flash[:error] = "Reminder could not be sent"
      end
    end
    redirect_to :action => 'settings'
  end
end
