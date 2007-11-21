class AccountController < ApplicationController
  
  before_filter :must_be_logged_in
  before_filter :must_be_team_member, :only => [:sort]
  
  def index
    redirect_to :action => 'settings'
    # @current_user = Person.find_by_id_and_account_id(session[:user], session[:account])
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
      @user = Person.find_by_id_and_account_id(session[:user], session[:account])
      if params[:old_password] == @user.password
        if @user.update_attributes(:password => params[:new_password], :password_confirmation => params[:new_password_confirmation])
          flash[:notice] = "Password changed successfully"
          redirect_to :action => 'settings' and return false
        else
          render :action => 'settings'
        end
      else
        flash[:error] = 'The password you entered is incorrect'
        redirect_to :action => 'settings' and return false
      end
    end
  end
  
  def sort
    @user_stories = @account.user_stories
    @user_stories.each do |story| 
      story.position = params['userstorylist'].index(story.id.to_s) + 1 
      story.save 
    end 
    render :nothing => true 
  end
  
  def resend_authentication
    if request.post?
      @person = @account.people.find(params[:id])
      if NotificationMailer.deliver_account_invitation(@person, @account, self)
        flash[:notice] = "Reminder sent successfully"
      else
        flash[:error] = "Reminder could not be sent"
      end
    end
    redirect_to :action => 'settings'
  end
  
end
