class Burndown < ActiveRecord::Base
  belongs_to :sprint
  validates :sprint_id, presence: true

  default_scope { order("created_on") }

  def self.generate!(sprint, date)
    burndown = Burndown.find_or_create_by(sprint_id: sprint.id, created_on: date)
    burndown.hours_left = sprint.hours_left
    burndown.story_points_complete = sprint.story_points_burned
    burndown.story_points_remaining = sprint.total_story_points
    burndown.save!
  end

  def self.calculate_today(sprint)
    return if sprint.nil?
    return unless sprint.start_at.to_date == Date.today
    CalculateBurnWorker.perform_async(Date.today, sprint.id)
  end

  def self.calculate_tomorrow(sprint)
    return if sprint.nil?
    CalculateBurnWorker.perform_async(Date.tomorrow, sprint.id)
  end

  def self.calculate_end(sprint)
    return if sprint.nil?
    CalculateBurnWorker.perform_async(1.day.from_now(sprint.end_at).to_date, sprint.id)
  end
end
