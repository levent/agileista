class Project < ActiveRecord::Base
  has_many :team_members, dependent: :destroy
  has_many :people, through: :team_members

  has_many :user_stories, -> { order('position') }, dependent: :destroy
  has_many :sprints, -> { order('start_at DESC') }, dependent: :destroy

  has_many :invitations, dependent: :destroy

  has_one :hip_chat_integration, dependent: :destroy
  has_one :slack_integration, dependent: :destroy

  validates :name, presence: true
  validates :iteration_length, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  def average_velocity
    relevant_sprints = sprints.finished.statistically_significant(self)
    return if relevant_sprints.empty?
    relevant_sprints.map(&:calculated_velocity).sum / relevant_sprints.count
  end

  def scrum_master
    people.where('scrum_master = ?', true).first
  end

  def scrum_master=(person)
    team_members.create!(person: person, scrum_master: true)
  end

  def integrations_notify(message)
    hipchat_notify(message)
    slack_notify(message)
  end

  def hipchat_notify(message)
    if hip_chat_integration.try(:required_fields_present?)
      HipChatWorker.perform_async(hip_chat_integration.token, hip_chat_integration.room, hip_chat_integration.notify?, message)
    end
  end

  def slack_notify(message)
    if slack_integration.try(:required_fields_present?)
      SlackWorker.perform_async(slack_integration.team, slack_integration.token, slack_integration.channel, message.gsub("<strong>", "").gsub("</strong>", ""))
    end
  end
end
