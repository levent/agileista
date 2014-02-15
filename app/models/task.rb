class Task < ActiveRecord::Base
  # acts_as_list :scope => :user_story
  include RankedModel
  ranks :order,
    :with_same => :user_story_id,
    :column => :position

  validates_presence_of :definition
  validates_length_of :definition, :maximum => 255
  # Screws up in accepts_nested_attributes_for
  # validates_uniqueness_of :definition, :scope => :user_story_id

  belongs_to :user_story, :touch => true

  has_many :task_developers, :dependent => :delete_all
  has_many :team_members, :through => :task_developers, :foreign_key => 'developer_id', :class_name => "Person", :uniq => true

  delegate :sprint, :to => :user_story, :allow_nil => true

  scope :complete, :conditions => "done = true"

  # Similar to above, but we're using these in the user_story/show context
  scope :not_done, :conditions => "done = false"

  after_save :calculate_burndown
  after_destroy :calculate_burndown

  def self.incomplete
    where("done = false").includes(:team_members).select {|x| x.team_members.blank?}
  end

  def self.inprogress
    where("done = false").includes(:team_members).select {|x| x.team_members.any?}
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
end
