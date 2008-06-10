class UserStory < ActiveRecord::Base
  
  # acts_as_versioned
  acts_as_ferret({:fields => { 
    :tag_string => {:boost => 2},
    :definition => {:boost => 1.5},
    :description => {},
    :active => {}
  }, :remote => true})

  has_many :sprint_elements, :dependent => :delete_all
  has_many :sprints, :through => :sprint_elements
  has_many :acceptance_criteria
  # has_many :themes

  acts_as_list :scope => :account
  
  validates_presence_of :definition
  validates_presence_of :account_id
  validates_uniqueness_of :definition, :scope => :account_id
  
  has_many :tasks, :order => :position
  belongs_to :account
  
  # This is only used (sprint_id field) to indicate whether a user story is planned or not (that's all it seems)
  #  Please see action > estimated_account_user_stories
  belongs_to :sprint
  belongs_to :person
  belongs_to :release


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
  # def done?
  #   self.done == 1 ? true : false
  # end
  
  def tag_with(tags)
    self.taggings.destroy_all
    tags.split(" ").each do |tag|
      Tag.find_or_create_by_name_and_account_id(tag,self.account_id).taggables << self
    end
  end
  
  alias :tags= :tag_with
  
  def theme_with(themes)
    self.themings.destroy_all
    return unless themes
    # new_themes = []
    themes.each do |theme|
      Theme.find_or_create_by_name_and_account_id(theme,self.account_id).themables << self
    end
    # old_themes = self.themings - new_themes
    # old_themes.collect{|x| x.destroy}
  end
  
  alias :themes= :theme_with
  
  def tag_string
    self.tags.map(&:name).join(' ')
  end
  
  def active
    # :conditions => ["done = ? AND sprint_id IS ?", 0, nil]
    if self.done == 0 && self.sprint.blank?
      return "yes"
    else
      return "no"
    end
  end
  
  def copy
    new_us = self.clone
    # new_us.acceptance_criteria = self.acceptance_criteria
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
    until self.errors.on(:definition).blank? || try > 25
      self.definition = "#{original_definition} - (#{try.ordinalize} copy)"
      self.valid?
      try += 1
    end
    self.definition
  end
  
end