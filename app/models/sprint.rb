class Sprint < ActiveRecord::Base
  has_many :sprint_elements, -> { order('sprint_elements.position') }, dependent: :delete_all
  has_many :user_stories, -> { includes(:sprint_elements).order('sprint_elements.position') }, through: :sprint_elements
  has_many :burndowns

  belongs_to :project
  validates :project_id, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :name, presence: true

  before_validation :calculate_end_date

  scope :current, -> { where(["start_at <= ? AND end_at > ?", Date.today.beginning_of_day, Date.today.beginning_of_day]) }
  scope :finished, -> { where(["end_at < ?", Time.zone.now.beginning_of_day]) }
  scope :statistically_significant, ->(account) { where(["end_at > ?", Velocity.stats_significant_since(account)]) }

  def validate
    return unless start_at && end_at
    errors.add(:start_at, "and end at must be different") if start_at >= end_at
  end

  def calculate_day_zero
    return false if start_at <= Time.zone.now
    burndown = Burndown.find_or_create_by(sprint_id: id, created_on: start_at.to_date)
    burndown.hours_left = hours_left
    burndown.story_points_complete = story_points_burned
    burndown.story_points_remaining = total_story_points
    burndown.save
  end

  def calculated_velocity
    return '-' unless finished?
    velocity || calculate_velocity!
  end

  def total_story_points
    pts = REDIS.get("sprint:#{id}:total_story_points")
    unless pts
      pts = user_stories.sum('story_points')
      REDIS.set("sprint:#{id}:total_story_points", pts)
      REDIS.expire("sprint:#{id}:total_story_points", REDIS_EXPIRY)
    end
    pts
  end

  def expire_total_story_points
    REDIS.del("sprint:#{id}:total_story_points")
  end

  def story_points_burned
    tally = 0
    user_stories.each do |us|
      tally += us.story_points if us.story_points && us.complete?
    end
    tally
  end

  def calculate_velocity!
    self.velocity = story_points_burned
    save!
    velocity
  end

  def hours_left
    Task.where("user_story_id IN (?) AND done = ?", user_story_ids, false).count
  end

  def finished?
    end_at < Time.zone.now.at_beginning_of_day
  end

  def current?
    start_at <= Date.today.beginning_of_day && end_at > Date.today.beginning_of_day
  end

  def calculate_end_date
    if end_at
      self.end_at = end_at.end_of_day
    elsif project
      self.end_at = project.iteration_length.to_i.weeks.from_now(1.day.ago(start_at)).end_of_day
    end
  end

  def destroy
    user_stories.each do |us|
      us.sprint_id = nil
      us.save!
    end
    super
  end
end
