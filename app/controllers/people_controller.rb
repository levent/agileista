class PeopleController < AbstractSecurityController

  def index
    @people = @project.people
    @invitations = @project.invitations
  end

end

