class Project < ActiveRecord::Base
  
  belongs_to :account
  validates_presence_of :account
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :account_id
  
  has_many :user_stories, :order => :position
  
  has_many :project_members
  has_many :people, :through => :project_members
  
end
