class Theme < ActiveRecord::Base
  belongs_to :account
  validates_presence_of :name
  acts_as_list :scope => :account

  has_many :themings, :foreign_key => "theme_id"
  has_many :user_stories, :through => :themings

  # has_many_polymorphs :themables,
  #     :from => [:user_stories],
  #     :through => :themings,
  #     :dependent => :destroy
      
  def story_points
    @story_points = 0
    self.user_stories.collect{|x| @story_points += x.story_points if x.story_points}
    return @story_points
  end
  
  def story_points_left
    @story_points = self.story_points
    # self.user_stories.find(:all, :conditions => ["done = ? AND sprint_id IS ?", 0, nil]).collect{|x| @story_points += x.story_points if x.story_points}
    self.user_stories.each do |us|
      @story_points -= us.story_points if us.complete?
    end
    return @story_points
  end
end