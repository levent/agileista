require 'digest/sha1'

class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, authentication_keys: [:email, :account_id]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  include Gravtastic
  gravtastic

  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email, :scope => :account_id, :case_sensitive => false
  belongs_to :account
  has_many :user_stories
  has_many :task_developers, :foreign_key => "developer_id"
  has_many :tasks, :through => :task_developers

  before_create :generate_activation_code
  before_save :downcase_email

  scope :active, :conditions => {:authenticated => true}
  scope :inactive, :conditions => {:authenticated => false}

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

  def validate_account
    self.authenticated = 1
    self.activation_code = nil
    return self.save
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
  
  def account_holder?
    self == self.account.account_holder
  end
  
  def can_delete_users?
    account_holder?
  end
  
  protected
  
  def generate_activation_code
    self.activation_code = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.email}--")
  end
  
  def password_required?
    self.hashed_password && self.salt ? false : true
  end

  def downcase_email
    self.email.try(:downcase!)
  end
end
