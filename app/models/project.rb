class Project < ActiveRecord::Base
  has_many :team_members, :dependent => :destroy
  has_many :people, :through => :team_members

  has_many :user_stories, -> {order('position')}, :dependent => :destroy
  has_many :sprints, -> {order('start_at DESC')}, :dependent => :destroy

  has_many :invitations, :dependent => :destroy

  has_one :hip_chat_integration, :dependent => :destroy
  has_one :slack_integration, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :iteration_length
  validates_uniqueness_of :name, :case_sensitive => false

  attr_accessible :name, :iteration_length

  def average_velocity
    relevant_sprints = sprints.finished.statistically_significant(self)
    return if relevant_sprints.empty?
    relevant_sprints.map {|s| s.calculated_velocity}.sum / relevant_sprints.count
  end

  def scrum_master
    people.where('scrum_master = ?', true).first
  end

  def scrum_master=(person)
    team_members.create!(:person => person, :scrum_master => true)
  end

  def integrations_notify(message)
    hipchat_notify(message)
    slack_notify(message)
  end

  def hipchat_notify(message)
    if self.hip_chat_integration && self.hip_chat_integration.required_fields_present?
      HipChatWorker.perform_async(self.hip_chat_integration.token, self.hip_chat_integration.room, self.hip_chat_integration.notify?, message)
    end
  end

  def slack_notify(message)
    if self.slack_integration && self.slack_integration.required_fields_present?
      SlackWorker.perform_async(self.slack_integration.team, self.slack_integration.token, self.slack_integration.channel, message.gsub("<strong>", "").gsub("</strong>", ""))
    end
  end
end
