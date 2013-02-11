class TeamMembersController < AbstractSecurityController
  def destroy
    @team_member = @project.team_members.find_by_person_id(params[:id])
    if @team_member.destroy
      flash[:notice] = "#{@team_member.person.name} removed from #{@project.name.humanize}"
      redirect_to project_people_path(@project)
    end
  end
end
