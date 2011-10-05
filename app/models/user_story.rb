class UserStory < ActiveRecord::Base
  define_index do
    indexes tags.name, :as => :tag_string
    indexes definition
    indexes description
    indexes [stakeholder, person.name], :as => :responsible
    has account(:id), :as => :account_id
    where "done = 0 AND sprint_id IS NULL"
    set_property :delta => true
  end

  acts_as_taggable_on :tags

  has_many :themings, :foreign_key => "themable_id"
  has_many :themes, :through => :themings
  has_many :sprint_elements, :dependent => :delete_all
  has_many :sprints, :through => :sprint_elements
  has_many :acceptance_criteria
  accepts_nested_attributes_for :acceptance_criteria, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  acts_as_list :scope => :account

  validates_presence_of :definition
  validates_presence_of :account_id
  validates_uniqueness_of :definition, :scope => :account_id

  has_many :tasks, :order => :position
  accepts_nested_attributes_for :tasks, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  belongs_to :account

  # This is only used (sprint_id field) to indicate whether a user story is planned or not (that's all it seems)
  #  Please see action > estimated_account_user_stories
  belongs_to :sprint
  belongs_to :person

  named_scope :stale,
    lambda { |range|
    { 
      :conditions => ['done = ? AND updated_at < ?', 0, range]
    }
  }
  named_scope :estimated, :conditions => ['done = ? AND sprint_id IS ? AND story_points IS NOT ?', 0, nil, nil]
  named_scope :unassigned,
    lambda {|order|
        {
          :conditions => ['done = ? AND sprint_id IS ?', 0, nil],
          :order => order, :include => [:acceptance_criteria, :person]
        }
    }

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
        return false unless task.complete?
      end
      return true
    else
      return false
    end
  end

  def self.complete_tasks
    complete_tasks = []
    find(:all).each do |user_story|
      user_story.tasks.each do |task|
        complete_tasks << task if task.complete?
      end
    end
    return complete_tasks
  end

  def self.inprogress_tasks
    inprogress_tasks = []
    find(:all).each do |user_story|
      user_story.tasks.each do |task|
        inprogress_tasks << task if task.inprogress?
      end
    end
    return inprogress_tasks
  end

  def self.incomplete_tasks
    incomplete_tasks = []
    find(:all).each do |user_story|
      user_story.tasks.each do |task|
        incomplete_tasks << task if task.incomplete?
      end
    end
    return incomplete_tasks
  end

  def total_hours
    self.tasks.sum('hours')
  end
  
  def state
    if self.cannot_be_estimated?
      return "clarify"
    elsif self.story_points.blank?
      return self.acceptance_criteria.blank? ? "criteria" : "estimate"
    else
      return "plan"
    end
  end

  def copy
    new_us = self.clone
    self.acceptance_criteria.each do |ac|
      new_us.acceptance_criteria << AcceptanceCriterium.new(ac.attributes)
    end
    self.tasks.each do |task|
      new_us.tasks << Task.new(:hours => task.hours, :definition => task.definition) unless task.complete?
    end
    new_us.definition = new_us.unique_definition
    new_us.sprint_id = nil
    saved = new_us.save
    new_us.move_to_top if saved
    return saved
  end

  def unique_definition
    return if self.valid?
    try = 2
    original_definition = self.definition
    # =~ /( - \((([\d])(th|nd|st|rd)) copy\))/
    until self.errors.on(:definition).blank? || try > 25
      subbed_def = self.definition.gsub(/( - \((([\d]+)(th|nd|st|rd)) copy\))/, '')
      self.definition = "#{subbed_def} - (#{($3.to_i + 1).ordinalize} copy)"
      self.valid?
      try += 1
    end
    self.definition
  end
end

