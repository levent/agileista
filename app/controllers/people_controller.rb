class PeopleController < AbstractSecurityController

#  ssl_allowed :new, :create, :delete, :edit, :update
  before_filter :must_be_account_holder, :except => [:index, :edit, :update]
  before_filter :can_i_edit_them, :only => [:edit, :update]

  def index
    @people = @account.people
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    pass = @person.generate_temp_password
    @person.account = @account
    if @person.save
      NotificationMailer.account_invitation(@person, @account, pass).deliver
      flash[:notice] = "Invitation sent"
      redirect_to people_path
    else
      flash[:error] = "There were errors creating the invitation"
      render :action => 'new'
    end
  end

  def destroy
    @person = @account.people.find(params[:id])
    redirect_to :controller => 'account', :action => 'settings' and flash[:error] = "You cannot delete the account holder" and return false if @person == current_user
    if @person.destroy
      flash[:notice] = "User deleted successfully"
    else
      flash[:error] = "User could not be deleted"
    end
    redirect_to account_path
  end

  def edit
  end

  def update
    unless (@person == current_user) || (@person.account_holder?)
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

