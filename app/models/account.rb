class Account < ActiveRecord::Base
  acts_as_tagger

  has_many :people, :order => 'name', :dependent => :destroy
  has_many :team_members, :order => 'name', :dependent => :destroy, :class_name => "Person"
  has_many :sprints, :order => 'start_at DESC', :dependent => :destroy
  has_many :user_stories, :order => :position, :dependent => :destroy

  belongs_to :account_holder, :class_name => "Person", :foreign_key => 'account_holder_id'

  validates_presence_of :name
  validates_presence_of :subdomain
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_format_of :subdomain, :with => /^[A-Za-z]+[-A-Za-z0-9]*[A-Za-z0-9]+$/, :message => "may only contain numbers and letters"
  after_create :invite_account_holder
  before_validation :make_fields_lowercase

  attr_accessor :account_holder_email

  def invite_account_holder
    debugger
    puts 'debugger'
    generated_password = Devise.friendly_token.first(6)
    user = Person.create(:email => self.account_holder_email,
                         :password => generated_password)
    RegistrationMailer.welcome(user, generated_password).deliver
  end

  def median_velocity
    return if sprints.finished.statistically_significant(self).empty?
    sorted = sprints.finished.statistically_significant(self).map {|s| s.calculated_velocity}.sort
    (sorted[sorted.length/2] + sorted[(sorted.length + 1) / 2]) / 2
  end

  def average_velocity
    return if sprints.finished.statistically_significant(self).empty?
    sprints.finished.statistically_significant(self).map {|s| s.calculated_velocity}.sum / sprints.finished.statistically_significant(self).count
  end

  def authenticate(email, password)
    person = self.people.find_by_email_and_authenticated_and_activation_code(email.try(:downcase), 1, nil)
    return false unless person
    if person.hashed_password == person.encrypt(password)
      person
    else
      false
    end
  end

  private

  def make_fields_lowercase
    self.name.downcase! if self.name
    self.subdomain.downcase! if self.subdomain
  end
end
