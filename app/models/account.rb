class Account < ActiveRecord::Base
  has_many :people, :order => 'name'
  has_many :team_members, :order => 'name'
  has_many :contributors, :order => 'name'
  has_many :sprints, :order => 'start_at DESC'
  has_many :user_stories, :order => :position
  has_many :impediments, :order => 'resolved_at, created_at DESC'
  belongs_to :account_holder, :class_name => "Person", :foreign_key => 'account_holder_id'
  
  validates_presence_of :name, :message => "of account can't be blank"
  validates_uniqueness_of :name, :message => "of account has already been taken"
  
  before_save :make_name_lowercase
  
  has_many :themes, :order => 'name'
  has_many :releases
  has_many :tags
  
  private
  
  def make_name_lowercase
    self.name.downcase!
  end
end