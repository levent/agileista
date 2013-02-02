class AccountController < AbstractSecurityController
  def index
    @user = current_user
    render :action => 'settings'
  end

  def settings
    if @account.update_attributes(params[:account])
      flash[:notice] = "Settings saved"
      redirect_to :controller => 'backlog' and return false
    else
      flash[:error] = "Settings couldn't be saved"
    end
  end

  def change_password
    @user = current_user
    if @account.authenticate(current_user.email, params[:person].delete(:old_password))
      if @user.update_attributes(:password => params[:person][:password], :password_confirmation => params[:person][:password_confirmation])
        flash[:notice] = "Password changed successfully"
        redirect_to root_path
      else
        render :action => 'settings'
      end
    else
      flash[:error] = "The password you entered didn't match"
      redirect_to account_path
    end
  end

  def resend_authentication
    @person = @account.people.find(params[:id])
    pass = @person.generate_temp_password
    if NotificationMailer.account_invitation(@person, @account, pass).deliver
      flash[:notice] = "Reminder sent successfully"
    else
      flash[:error] = "Reminder could not be sent"
    end
    redirect_to account_path
  end

  def generate_api_key
    current_user.update_attribute(:api_key, Digest::SHA256.hexdigest("#{Time.now}---#{rand(10000)}"))
    redirect_to account_path
  end
end
