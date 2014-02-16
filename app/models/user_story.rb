require 'csv'
class UserStory < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  index_name 'user_stories-2013-11-29'

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

  attr_accessible :definition, :story_points, :stakeholder, :cannot_be_estimated, :description, :acceptance_criteria_attributes, :tasks_attributes

  def search_ac
    self.acceptance_criteria.collect(&:detail)
  end

  def search_tasks
    self.tasks.collect(&:definition)
  end

  def tags
    self.definition.scan(/\[(\w+)\]/).uniq.flatten.map(&:downcase)
  end

  after_touch() { tire.update_index }

  has_many :sprint_elements, dependent: :delete_all
  has_many :sprints, through: :sprint_elements
  has_many :acceptance_criteria, -> {order('position')}, dependent: :delete_all
  has_many :tasks, -> {order('position')}, dependent: :destroy
  accepts_nested_attributes_for :acceptance_criteria, allow_destroy: true, reject_if: proc { |attrs| attrs.all? { |k, v| v.blank? } }

  include RankedModel
  ranks :backlog_order,
    with_same: :project_id,
    column: :position,
    scope: :unassigned

  validates_presence_of :definition
  validates_presence_of :project_id

  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: proc { |attrs| attrs.all? { |k, v| v.blank? } }
  belongs_to :project

  # This is only used (sprint_id field) to indicate whether a user story is planned or not (that's all it seems)
  #  Please see action > estimated_account_user_stories
  belongs_to :sprint
  belongs_to :person

  after_save :expire_story_points
  after_save :expire_status, :expire_state
  after_save :expire_sprint_story_points
  after_touch :expire_status, :expire_state
  after_destroy :expire_story_points

  scope :estimated, -> {where(['sprint_id IS ? AND story_points IS NOT ?', nil, nil])}
  scope :unassigned, -> {where(sprint_id: nil)}

  def as_json(options = {})
    super(options.merge(only: [:definition, :description, :stakeholder, :story_points, :updated_at, :created_at]))
  end

  def to_json(options = {})
    super(options.merge(only: [:definition, :description, :stakeholder, :story_points, :updated_at, :created_at]))
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << columns = [:id, :definition, :description, :stakeholder, :story_points, :updated_at, :created_at].map(&:to_s)
      all.each do |product|
        csv << product.attributes.values_at(*columns)
      end
    end
  end

  def stakeholder
    super.blank? ? person.try(:name) : super
  end

  def status
    cached_status = REDIS.get("user_story:#{self.id}:status")
    unless cached_status
      if self.inprogress?
        cached_status = "inprogress"
      elsif self.complete?
        cached_status = "complete"
      else
        cached_status = "incomplete"
      end
      REDIS.set("user_story:#{self.id}:status", cached_status)
      REDIS.expire("user_story:#{self.id}:status", REDIS_EXPIRY)
    end
    cached_status
  end

  def inprogress?
    if !tasks.blank?
      tasks.each do |task|
        return true if task.inprogress?
      end
      return false
    else
      return false
    end
  end

  def complete?
    if !tasks.blank?
      tasks.each do |task|
        return false unless task.done?
      end
      return true
    else
      return false
    end
  end

  def state
    cached_state = REDIS.get("user_story:#{self.id}:state")
    unless cached_state
      if self.cannot_be_estimated?
        cached_state = 'clarify'
      elsif self.acceptance_criteria.blank?
        cached_state = 'criteria'
      elsif self.story_points.blank?
        cached_state = 'estimate'
      else
        cached_state = 'plan'
      end
      REDIS.set("user_story:#{self.id}:state", cached_state)
      REDIS.expire("user_story:#{self.id}:state", REDIS_EXPIRY)
    end
    cached_state
  end

  def copy!
    new_us = UserStory.new(project_id: self.project_id, person_id: self.person_id, stakeholder: self.stakeholder, definition: self.definition, description: self.description, story_points: self.story_points)
    self.acceptance_criteria.each do |ac|
      new_us.acceptance_criteria << AcceptanceCriterium.new(detail: ac.detail)
    end
    self.tasks.each do |task|
      new_us.tasks << Task.new(definition: task.definition, description: task.description, done: task.done)
    end
    new_us.backlog_order_position = :first
    new_us.save!
  end

  def self.search_by_query(search_query, page, project_id, all_sprints = false)
    raise ArgumentError unless project_id
    UserStory.search(per_page: 100, page: page, load: true) do |search|
      search.query do |query|
        query.filtered do |f|
          f.query do |q|
            q.string search_query, default_operator: "AND"
          end
          f.filter :missing , field: :sprint_id unless all_sprints
          f.filter :term, project_id: project_id
        end
      end
      search.facet('tags') do
        terms :tag
      end
    end
  end

  private

  def expire_status
    REDIS.del("user_story:#{self.id}:status")
  end

  def expire_state
    REDIS.del("user_story:#{self.id}:state")
  end

  def expire_story_points
    REDIS.del("project:#{self.project.id}:story_points")
  end

  def expire_sprint_story_points
    sprint.try(:expire_total_story_points)
    sprints.map(&:expire_total_story_points)
  end
end
