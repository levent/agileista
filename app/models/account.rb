class Account < ActiveRecord::Base
  acts_as_tagger
  
  has_many :people, :order => 'name', :dependent => :destroy
  has_many :team_members, :order => 'name'
  has_many :contributors, :order => 'name'
  has_many :sprints, :order => 'start_at DESC', :dependent => :destroy
  has_many :user_stories, :order => :position, :dependent => :destroy
  has_many :impediments, :order => 'resolved_at, created_at DESC', :dependent => :destroy
  has_many :themes, :order => 'name', :dependent => :destroy
  has_many :releases, :dependent => :destroy
  # has_many :tags, :dependent => :destroy
  
  belongs_to :account_holder, :class_name => "Person", :foreign_key => 'account_holder_id'
  
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_format_of :subdomain, :with => /^[-A-Za-z0-9]+$/, :message => "may only contain numbers and letters"
  
  before_validation :make_fields_lowercase
  
  # def calculated_velocity
  #   self.velocity || calculate_velocity
  # end
  # 
  # def calculate_velocity
  #   unless self.sprints.any?
  #     self.velocity = 0
  #   else
  #     finished_sprints = 0
  #     tally = 0
  #     self.sprints.each do |sprint|
  #       if sprint.finished?
  #         tally += sprint.calculated_velocity
  #         finished_sprints += 1
  #       end
  #     end
  #     if finished_sprints == 0
  #       self.velocity = 0
  #     else
  #       self.velocity = (tally / finished_sprints)
  #     end
  #   end
  #   save!
  #   self.velocity
  # end
  
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