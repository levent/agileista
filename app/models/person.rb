require 'digest/sha1'

class Person < ActiveRecord::Base
  include Gravtastic
  is_gravtastic!
  
  validates_confirmation_of :password
  validates_length_of :password, :in => 6..16, :if => :password_required?
  validates_presence_of :name
  validates_presence_of :email
  # validates_presence_of :account_id
  validates_uniqueness_of :email, :scope => :account_id
  belongs_to :account  
  has_many :user_stories
  
  before_create :generate_activation_code
  before_save :hash_password
  
  attr_accessor :password
  
  named_scope :active, :conditions => {:authenticated => true}
  named_scope :inactive, :conditions => {:authenticated => false}
  
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
    self.salt = Digest::SHA1.hexdigest("#{Time.now}--#{PEOPLE_SALT}") if self.new_record? || self.salt.blank?
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
  
  # OBSOLETE - @account.authenticate instead
  # def self.basic_authenticate(email, password)
  #   self.find_by_email_and_password(email, password)
  # end
  
  protected
  
  def generate_activation_code
    self.activation_code = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.email}--")
  end
  
  def password_required?
    self.hashed_password && self.salt ? false : true
  end
end
