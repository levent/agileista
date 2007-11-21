class Release < ActiveRecord::Base
  
  belongs_to :account
  validates_presence_of :name
  
  has_many :user_stories, :order => "position"
  
  def story_points
    @story_points = 0
    self.user_stories.collect{|x| @story_points += x.story_points if x.story_points}
    return @story_points
  end
  
end
