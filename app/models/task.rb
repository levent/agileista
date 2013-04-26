class Task < ActiveRecord::Base
  # acts_as_list :scope => :user_story
  include RankedModel
  ranks :order,
    :with_same => :user_story_id,
    :column => :position

  validates_presence_of :definition
  validates_presence_of :hours
  validates_length_of :definition, :maximum => 255
  # Screws up in accepts_nested_attributes_for
  # validates_uniqueness_of :definition, :scope => :user_story_id

  belongs_to :user_story, :touch => true
  # belongs_to :developer, :foreign_key => 'developer_id', :class_name => "Person"

  has_many :task_developers, :dependent => :delete_all
  has_many :team_members, :through => :task_developers, :foreign_key => 'developer_id', :class_name => "Person", :uniq => true

  delegate :sprint, :to => :user_story, :allow_nil => true

  # named_scope :incomplete, :conditions => "developer_id IS NULL && (hours > 0 OR hours IS NULL)"
  # named_scope :inprogress, :conditions => "(developer_id IS NOT NULL AND hours > 0) OR (developer_id IS NOT NULL AND hours IS NULL)"
  scope :complete, :conditions => "hours = 0"

  # Similar to above, but we're using these in the user_story/show context
  scope :not_done, :conditions => "hours > 0 OR hours IS NULL"

  after_save :calculate_burndown
  after_destroy :calculate_burndown

  def self.incomplete
    where("hours > 0 OR hours IS NULL").includes(:team_members).select {|x| x.team_members.blank?}
  end

  def self.inprogress
    where("hours > 0 OR hours IS NULL").includes(:team_members).select {|x| x.team_members.any?}
  end

  def calculate_burndown
    self.user_story.sprint.calculate_day_zero if self.sprint
  end

  def complete?
    self.hours == 0
  end

  def incomplete?
    return false if team_members.any?
    return true if hours.nil?
    hours.to_i > 0
  end

  def inprogress?
    return false unless team_members.any?
    return true if hours.nil?
    hours.to_i > 0
  end

end
