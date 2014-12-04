class Task < ActiveRecord::Base
  # acts_as_list scope: :user_story
  include RankedModel
  ranks :order,
    with_same: :user_story_id,
    column: :position

  validates_presence_of :definition
  validates_length_of :definition, maximum: 255
  # Screws up in accepts_nested_attributes_for
  # validates_uniqueness_of :definition, scope: :user_story_id

  belongs_to :user_story, touch: true

  has_many :task_developers, dependent: :delete_all
  has_many :team_members, -> {uniq}, through: :task_developers, foreign_key: 'developer_id', class_name: "Person"

  attr_accessible :definition, :description

  delegate :sprint, to: :user_story, allow_nil: true

  after_save :calculate_burndown
  after_destroy :calculate_burndown
  after_save :expire_assignees
  after_touch :expire_assignees

  def assignees
    devs = REDIS.get("task:#{self.id}:assignees")
    unless devs
      devs = self.team_members.map(&:name).join(',')
      REDIS.set("task:#{self.id}:assignees", devs)
      REDIS.expire("task:#{self.id}:assignees", REDIS_EXPIRY)
    end
    devs
  end

  def self.filter_for_incomplete(tasks)
    tasks.to_a.delete_if {|t| t.done == true}.select {|x| x.assignees.blank?}
  end

  def self.filter_for_inprogress(tasks)
    tasks.to_a.delete_if {|t| t.done == true}.select {|x| x.assignees.present?}
  end

  def self.filter_for_complete(tasks)
    tasks.to_a.delete_if {|t| t.done == false}
  end

  def calculate_burndown
    self.user_story.sprint.calculate_day_zero if self.sprint
  end

  def inprogress?
    !self.done? && team_members.any?
  end

  def hours
    self.done? ? 0 : 1
  end

  private

  def expire_assignees
    REDIS.del("task:#{self.id}:assignees")
  end
end
