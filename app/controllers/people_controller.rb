class PeopleController < AbstractSecurityController

  def index
    @people = @project.people.order('name')
    @invitations = @project.invitations.order('email')
  end

end

