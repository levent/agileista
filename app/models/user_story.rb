require 'csv'
class UserStory < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include ElasticSearchable
  include Formatters
  include SprintPlannable
  include State

  mapping do
    indexes :id, index: :not_analyzed
    indexes :definition, analyzer: 'snowball', boost: 100
    indexes :description, analyzer: 'snowball', boost: 50
    indexes :stakeholder, analyzer: 'simple'
    indexes :story_points, type: 'integer', index: :not_analyzed
    indexes :project_id, type: 'integer', index: :not_analyzed
    indexes :sprint_id, type: 'integer', index: :not_analyzed
    indexes :created_at, type: 'date', include_in_all: false
    indexes :tag, analyzer: 'keyword', as: 'tags'
    indexes :search_ac, analyzer: 'snowball', as: 'search_ac'
    indexes :search_task, analyzer: 'snowball', as: 'search_tasks'
    indexes :state, analyzer: 'keyword', as: 'state'
  end

  after_touch { tire.update_index }

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

  after_save :expire_story_points
  after_save :expire_status, :expire_state
  after_save :expire_sprint_story_points
  after_touch :expire_status, :expire_state
  after_destroy :expire_story_points

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

  def expire_sprint_story_points
    sprint.try(:expire_total_story_points)
    sprints.map(&:expire_total_story_points)
  end
end
