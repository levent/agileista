require 'digest/sha1'

class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
# attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  include Gravtastic
  gravtastic

  validates_presence_of :name
  has_many :user_stories
  has_many :task_developers, foreign_key: "developer_id"
  has_many :tasks, through: :task_developers
  has_many :team_members, dependent: :destroy
  has_many :projects, -> {order('LOWER(projects.name)')}, through: :team_members

  # Used to migrate pre-devise users
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

  def encrypt(password)
    Digest::SHA1.hexdigest("#{self.salt}--#{password}")
  end

  def scrum_master_for?(project)
    scrum_master_email = REDIS.get("project:#{project.id}:scrum_master")
    unless scrum_master_email
      scrum_master_email = project.scrum_master.try(:email)
      REDIS.set("project:#{project.id}:scrum_master", scrum_master_email)
      REDIS.expire("project:#{project.id}:scrum_master", REDIS_EXPIRY)
    end
    scrum_master_email == self.email
  end

  def admin?
    ENV['admin_email'].present? && ENV['admin_email'] == email
  end
end
