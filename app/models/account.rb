class Account < ActiveRecord::Base
  
  # has_many :people, :through => :memberships
 #  has_many :memberships

  has_many :people, :order => 'name'
  has_many :team_members, :order => 'name'
  has_many :contributors, :order => 'name'
  
  has_many :projects
  has_many :sprints, :order => 'start_at DESC'
  has_many :user_stories, :order => :position
  # has_many :user_stories
  belongs_to :account_holder, :class_name => "Person", :foreign_key => 'account_holder_id'
  
  validates_presence_of :name, :message => "of account can't be blank"
  validates_uniqueness_of :name, :message => "of account has already been taken"
  #validates_presence_of :account_holder_id
  
  before_save :make_name_lowercase
  
  has_many :themes
  has_many :releases
  has_many :tags


  private
  
  def make_name_lowercase
    self.name.downcase!
  end
  
  
end
