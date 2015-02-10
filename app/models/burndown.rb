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
end
