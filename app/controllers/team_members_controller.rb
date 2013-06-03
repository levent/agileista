class TeamMembersController < AbstractSecurityController

  def destroy
    @team_member = @project.team_members.find_by_person_id(params[:id])
    unless current_person.scrum_master_for?(@project) || current_person == @team_member.person
      flash[:error] = "Unauthorized"
      redirect_to project_backlog_index_path(@project) and return false
    end
    if @team_member.destroy
      flash[:notice] = "#{@team_member.person.name} removed from #{@project.name.humanize}"
      redirect_to project_people_path(@project)
    end
  end

end
