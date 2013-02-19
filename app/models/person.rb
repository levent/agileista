require 'digest/sha1'

class Person < ActiveRecord::Base
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  include Gravtastic
  gravtastic

  validates_presence_of :name
  has_many :user_stories
  has_many :task_developers, :foreign_key => "developer_id"
  has_many :tasks, :through => :task_developers
  has_many :team_members, :dependent => :destroy
  has_many :projects, :through => :team_members, :order => 'name'

  def valid_password?(password)
    if self.hashed_password.present?
      if self.hashed_password == self.encrypt(password)
        self.password = password
        self.hashed_password = nil
        self.confirm!
        self.save!
        return true
      else
        return false
      end
    else
      super
    end
  end

  def authenticated?
    if self.authenticated == 1 && self.activation_code.nil?
      return true
    else
      return false
    end
  end
  
  def hash_password
    return nil unless self.password
    self.salt = Digest::SHA1.hexdigest("#{Time.now}--somecrazyrandomstring") if self.new_record? || self.salt.blank?
    self.hashed_password = Digest::SHA1.hexdigest("#{self.salt}--#{self.password}") if !self.hashed_password || (self.password == self.password_confirmation)
  end
  
  def encrypt(password)
    Digest::SHA1.hexdigest("#{self.salt}--#{password}")
  end
  
  def generate_temp_password
    pass = Digest::SHA1.hexdigest("#{Time.now}---#{self.email}")[0..8]
    self.password = pass
    self.password_confirmation = pass
    return pass
  end

  def scrum_master_for?(project)
    project.team_members.where('scrum_master = ?', true).map(&:person).include?(self)
  end
end
