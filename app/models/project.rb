class Project < ActiveRecord::Base
  has_many :team_members, :dependent => :destroy
  has_many :people, :through => :team_members

  has_many :user_stories, :order => 'position', :dependent => :destroy
  has_many :sprints, :order => 'start_at DESC', :dependent => :destroy

  has_many :invitations, :dependent => :destroy

  has_one :hip_chat_integration, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :iteration_length
  validates_uniqueness_of :name

  def average_velocity
    return if sprints.finished.statistically_significant(self).empty?
    sprints.finished.statistically_significant(self).map {|s| s.calculated_velocity}.sum / sprints.finished.statistically_significant(self).count
  end

  def scrum_master
    people.where('scrum_master = ?', true).first
  end

  def scrum_master=(person)
    team_members.create!(:person => person, :scrum_master => true)
  end
end
