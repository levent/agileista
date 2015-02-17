require 'csv'
class UserStory < ActiveRecord::Base
  # include Tire::Model::Search
  # include Tire::Model::Callbacks
  # include ElasticSearchable
  include Formatters
  include SprintPlannable
  include State
  include Searchable

  # after_touch { tire.update_index }

  include RankedModel
  ranks :backlog_order,
        with_same: :project_id,
        column: :position,
        scope: :unassigned

  # sprint_id only used to indicate whether a user story is planned or not
  #  Please see action > estimated_account_user_stories
  belongs_to :sprint
  belongs_to :person
  belongs_to :project

  has_many :sprint_elements, dependent: :delete_all
  has_many :sprints, through: :sprint_elements
  has_many :acceptance_criteria, -> { order('position') }, dependent: :delete_all
  has_many :tasks, -> { order('position') }, dependent: :destroy, inverse_of: :user_story
  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: proc { |attrs| attrs.all? { |_, v| v.blank? } }
  accepts_nested_attributes_for :acceptance_criteria, allow_destroy: true, reject_if: proc { |attrs| attrs.all? { |_, v| v.blank? } }
  validates :definition, presence: true
  validates :project_id, presence: true

  scope :estimated, -> { where(['sprint_id IS ? AND story_points IS NOT ?', nil, nil]) }
  scope :unassigned, -> { where(sprint_id: nil) }

  def stakeholder
    super.blank? ? person.try(:name) : super
  end

  def copy!
    us = clone_story!
    acceptance_criteria.each do |ac|
      us.acceptance_criteria << AcceptanceCriterium.new(detail: ac.detail)
    end
    tasks.each do |task|
      new_task = Task.new(definition: task.definition, description: task.description, user_story_id: us.id)
      new_task.done = task.done
      us.tasks << new_task
    end
    us.backlog_order_position = :first
    us.save!
  end

  private

  def clone_story!
    new_us = project.user_stories.new(stakeholder: stakeholder, definition: definition, description: description, story_points: story_points)
    new_us.person = person
    new_us.save!
    new_us
  end
end
