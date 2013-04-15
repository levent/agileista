class CalculateBurnJob
  @queue = :calculate_burn

  def self.perform(date, sprint_id)
    burndown = Burndown.find_or_create_by_sprint_id_and_created_on(sprint_id, date)
    burndown.hours_left = burndown.sprint.hours_left
    burndown.story_points_complete = burndown.sprint.story_points_burned
    burndown.story_points_remaining = burndown.sprint.total_story_points
    burndown.save!
  end
end

