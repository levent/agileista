class CalculateBurnJob
  @queue = :calculate_burn

  def self.perform(date, sprint_id)
    burndown = Burndown.where(:sprint_id => sprint_id, :created_on => date).first
    burndown ||= Burndown.new(:sprint_id => sprint_id, :created_on => date)
    burndown.hours_left = burndown.sprint.hours_left
    burndown.story_points_complete = burndown.sprint.story_points_burned
    burndown.story_points_remaining = burndown.sprint.total_story_points
    burndown.save!
  end
end

