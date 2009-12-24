class UsersController < AbstractSecurityController

  ssl_allowed :new, :create, :delete, :edit, :update
  before_filter :must_be_account_holder, :except => [:index, :edit, :update]
  before_filter :can_i_edit_them, :only => [:edit, :update]

  def index
    @users = @account.people
  end

  def new
    @person = Person.new
  end

  def create
    if request.post?
      if params[:type] == "team_member"
        @person = TeamMember.new(params[:person])
      else
        @person = Contributor.new(params[:person])
      end
      pass = @person.generate_temp_password
      @person.account = @account
      if @person.save
        NotificationMailer.deliver_account_invitation(@person, @account, self, pass)
        flash[:notice] = "Invitation sent"
        redirect_to :action => "new"
      else
        flash[:error] = "There were errors creating the invitation"
        render :action => 'new'
      end
    end
  end

  def delete
    if request.post?
      @person = @account.people.find(params[:id])
      redirect_to :controller => 'account', :action => 'settings' and flash[:error] = "You cannot delete the account holder" and return false if @person == current_user
      if @person.destroy
        flash[:notice] = "User deleted successfully"
      else
        flash[:error] = "User could not be deleted"
      end
    end
    redirect_to :controller => 'account', :action => 'settings'
  end

  def edit
  end

  def update
    unless (@person == current_user) || (@person.account_holder?)
      if params[:type] == "team_member"
        @person.type = "TeamMember"
      else
        @person.type = "Contributor"
      end
      @person.save
    end
    if @person.update_attributes(params[:person])
      flash[:notice] = "User updated successfully"
      redirect_to :action => 'index'
    else
      flash[:error] = "User could not be updated"
      render :action => 'edit'
    end
  end

  private

  def can_i_edit_them
    @person = @account.people.find(params[:id])
    redirect_to :controller => 'account', :action => 'settings' unless (@person == current_user) || current_user.account_holder?
  end

end

