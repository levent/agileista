class Task < ActiveRecord::Base
  include RankedModel
  ranks :order,
        with_same: :user_story_id,
        column: :position

  validates :user_story, presence: true
  validates :definition, presence: true, length: { maximum: 255 }

  belongs_to :user_story, touch: true, inverse_of: :tasks

  has_many :task_developers, dependent: :delete_all
  has_many :team_members, -> { uniq }, through: :task_developers, foreign_key: 'developer_id', class_name: "Person"

  delegate :sprint, to: :user_story, allow_nil: true

  after_save :calculate_burndown
  after_destroy :calculate_burndown

  def assignees
    team_members.map(&:name).join(',')
  end

  # These methods were originally written for permormance reasons, to reduce db queries.
  # TODO: Revisit

  def self.without_complete_tasks(tasks)
    tasks.to_a.delete_if { |t| t.done == true }
  end

  def self.filter_for_incomplete(tasks)
    without_complete_tasks(tasks).select { |x| x.assignees.blank? }
  end

  def self.filter_for_inprogress(tasks)
    without_complete_tasks(tasks).select { |x| x.assignees.present? }
  end

  def self.filter_for_complete(tasks)
    tasks.to_a.delete_if { |t| t.done == false }
  end

  def calculate_burndown
    user_story.sprint.calculate_day_zero if sprint
  end

  def inprogress?
    !done? && team_members.any?
  end

  def hours
    done? ? 0 : 1
  end
end
