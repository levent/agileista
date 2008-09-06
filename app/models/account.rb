class Account < ActiveRecord::Base
  has_many :people, :order => 'name'
  has_many :team_members, :order => 'name'
  has_many :contributors, :order => 'name'
  has_many :sprints, :order => 'start_at DESC'
  has_many :user_stories, :order => :position
  has_many :impediments, :order => 'resolved_at, created_at DESC'
  belongs_to :account_holder, :class_name => "Person", :foreign_key => 'account_holder_id'
  
  validates_presence_of :name
  # validates_presence_of :subdomain
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_format_of :subdomain, :with => /^[-A-Za-z0-9]+$/, :message => "may only contain numbers and letters"
  
  before_validation :make_fields_lowercase
  
  has_many :themes, :order => 'name'
  has_many :releases
  has_many :tags
  
  def authenticate(email, password)
    person = self.people.find_by_email_and_authenticated_and_activation_code(email, 1, nil)
    return nil unless person
    if person.hashed_password == person.encrypt(password)
      return person
    else
      return nil
    end
  end
  
  private
  
  def make_fields_lowercase
    self.name.downcase! if self.name
    self.subdomain.downcase! if self.subdomain
  end
end