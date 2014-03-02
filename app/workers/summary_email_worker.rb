class SummaryEmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    daily.hour_of_day(18)
  end

  def perform
    TeamMember.where(deleted_at: nil, notify_by_email: true).each do |tm|
      person = tm.person
      person.update_attribute(:unsubscribe_token, SecureRandom.urlsafe_base64(25)) if person.unsubscribe_token.nil?
      project = tm.project
      sprint = project.sprints.current.first
      if sprint
        SprintMailer.summary_email(person, sprint).deliver
      end
    end
  end
end
