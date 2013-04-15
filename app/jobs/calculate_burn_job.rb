class CalculateBurnJob
  @queue = :calculate_burn

  def self.perform(date, sprint)
    burndown = Burndown.find_or_create_by_sprint_id_and_created_on(sprint.id, date)
    burndown.hours_left = sprint.hours_left
    burndown.story_points_complete = sprint.story_points_burned
    burndown.story_points_remaining = sprint.total_story_points
    burndown.save!
  end
end

