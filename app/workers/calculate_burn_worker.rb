class CalculateBurnWorker
  include Sidekiq::Worker

  def perform(date, sprint_id)
    burndown = Burndown.find_or_create_by(sprint_id: sprint_id, created_on: date)
    burndown.hours_left = burndown.sprint.hours_left
    burndown.story_points_complete = burndown.sprint.story_points_burned
    burndown.story_points_remaining = burndown.sprint.total_story_points
    burndown.save!
  end
end
