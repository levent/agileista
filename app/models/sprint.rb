class Sprint < ActiveRecord::Base

  has_many :sprint_elements, :dependent => :delete_all, :order => 'sprint_elements.position'
  has_many :user_stories, :through => :sprint_elements, :order => 'sprint_elements.position'
  has_many :burndowns
  has_many :sprint_changes, :as => :auditable
  has_many :audits, :class_name => "SprintChange"

  belongs_to :project
  validates_presence_of :project_id
  validates_presence_of :start_at, :end_at
  validates_presence_of :name

  before_validation :calculate_end_date

  scope :current, lambda { { :conditions => ["start_at <= ? AND end_at > ?", Date.today.beginning_of_day, Date.today.beginning_of_day] } }
  scope :finished, lambda { {:conditions => ["end_at < ?", Time.zone.now.beginning_of_day]} }
  scope :statistically_significant, lambda { |account| {:conditions => ["end_at > ?", Velocity.stats_significant_since(account)] } }

  def as_json(options = {})
    super(options.merge(:only => [:name, :goal, :start_at, :end_at, :created_at, :updated_at, :velocity], :methods => [:user_stories]))
  end

  def to_json(options = {})
    super(options.merge(:only => [:name, :goal, :start_at, :end_at, :created_at, :updated_at, :velocity], :methods => [:user_stories]))
  end

  def user_stories_json
    user_stories_json = user_stories.collect(&:as_json)
  end

  def validate
    return unless start_at && end_at
    errors.add(:start_at, "and end at must be different") if self.start_at >= self.end_at
  end

  def calculate_day_zero
    return false if self.start_at <= Time.zone.now
    @burndown = Burndown.find_or_create_by_sprint_id_and_created_on(self.id, self.start_at.to_date)
    @burndown.hours_left = self.hours_left
    @burndown.story_points_complete = self.story_points_burned
    @burndown.story_points_remaining = self.total_story_points
    @burndown.save
  end

  def calculated_velocity
    return 0 unless self.finished?
    self.velocity || calculate_velocity!
  end

  def total_story_points
    pts = REDIS.get("sprint:#{self.id}:total_story_points")
    unless pts
      pts = self.user_stories.sum('story_points')
      REDIS.set("sprint:#{self.id}:total_story_points", pts)
      REDIS.expire("sprint:#{self.id}:total_story_points", 900)
    end
    pts
  end

  def expire_total_story_points
    REDIS.del("sprint:#{self.id}:total_story_points")
  end

  def story_points_burned
    tally = 0
    self.user_stories.each do |us|
      tally += us.story_points if us.story_points && us.complete?
    end
    tally
  end

  def calculate_velocity!
    self.velocity = self.story_points_burned
    save!
    return self.velocity
  end

  def hours_left
    Task.where("user_story_id IN (?)", self.user_story_ids).sum('hours')
  end

  def finished?
    self.end_at < Time.zone.now.at_beginning_of_day
  end

  def upcoming?
    self.start_at > Time.zone.now.end_of_day
  end

  def current?
    self.start_at <= Date.today.beginning_of_day && self.end_at > Date.today.beginning_of_day
  end

  def calculate_end_date
    if self.end_at
      self.end_at = self.end_at.end_of_day
    elsif self.project
      self.end_at = self.project.iteration_length.to_i.weeks.from_now(1.day.ago(start_at)).end_of_day
    end
  end

  def destroy
    self.user_stories.each do |us|
      us.sprint_id = nil
      us.save!
    end
    super
  end
end

