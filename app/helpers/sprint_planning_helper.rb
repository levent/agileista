module SprintPlanningHelper
  
  def sprint_assignment(sprint)
    return "Unassigned" if sprint.blank?
  end
  
  def tasked?(user_story)
    if user_story.tasks.blank?
      return " undefined"
    else
      return " defined"
    end
  end
  
end
