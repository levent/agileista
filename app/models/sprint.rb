class Sprint < ActiveRecord::Base

  has_many :sprint_elements, :dependent => :delete_all, :order => 'sprint_elements.position'
  has_many :user_stories, :through => :sprint_elements, :order => 'sprint_elements.position'
  has_many :burndowns
  has_many :sprint_changes, :as => :auditable
  has_many :audits, :class_name => "SprintChange"

  belongs_to :account
  validates_presence_of :account_id
  validates_presence_of :start_at, :end_at
  validates_presence_of :name

  before_validation :calculate_end_date

  scope :current, lambda { { :conditions => ["start_at < ? AND end_at > ?", Time.now, 1.days.ago] } }
  scope :finished, lambda { {:conditions => ["end_at < ?", Time.now]} }

  def validate
    return unless start_at && end_at
    errors.add(:start_at, "and end at must be different") if self.start_at >= self.end_at
  end

  def calculate_day_zero
    return false if self.start_at <= Time.now
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
    self.user_stories.sum('story_points')
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
    count = 0
    self.user_stories.each do |us|
      count += us.tasks.sum('hours') if us.tasks.sum('hours').class == Fixnum
    end
    return count
  end

  def finished?
    self.end_at < Time.now
  end

  def upcoming?
    self.start_at > Time.now
  end

  def current?
    self.start_at < Time.now && self.end_at > Time.now
  end

  def calculate_end_date
    if self.end_at
      self.end_at = self.end_at.end_of_day
    elsif self.account
      self.end_at = self.account.iteration_length.to_i.weeks.from_now(1.day.ago(start_at)).end_of_day
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

