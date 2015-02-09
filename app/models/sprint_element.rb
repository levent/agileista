class SprintElement < ActiveRecord::Base
  include RankedModel
  ranks :sprint,
        with_same: :sprint_id,
        column: :position

  belongs_to :sprint
  belongs_to :user_story

  after_save :calculate_burndown
  after_destroy :calculate_burndown

  def calculate_burndown
    if sprint
      sprint.reload
      sprint.calculate_day_zero
    end
  end
end
