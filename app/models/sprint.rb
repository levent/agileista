class Sprint < ActiveRecord::Base
  
  has_many :sprint_elements, :dependent => :delete_all
  has_many :user_stories, :through => :sprint_elements, :order => 'done, position'
  has_many :burndowns
  
  belongs_to :account
  validates_presence_of :account
  validates_presence_of :start_at, :end_at
  validates_presence_of :name
  
  before_validation :calculate_end_date
  
  def validate
    errors.add(:start_at, "and end at must be different") if self.start_at >= self.end_at
    # errors.add(:start_at, "cannot overlap with another sprint") if !@account.sprints.blank? && (self.start_at <= @account.sprints.last.end_at)
  end
  
  def hours_left
    count = 0
    for us in self.user_stories
      count += us.tasks.sum('hours') if us.tasks.sum('hours').class == Fixnum
    end
    return count
  end
  
  def finished?
    self.end_at < Time.now ? true : false
  end
  
  def upcoming?
    self.start_at > Time.now ? true : false
  end
  
  def current?
    self.start_at < Time.now && self.end_at > 1.days.ago
  end
  
  def calculate_end_date
    unless self.end_at
      self.end_at = self.account.iteration_length.to_i.weeks.from_now(1.day.ago(self.start_at))
    end
  end
end