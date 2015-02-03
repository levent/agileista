class SummaryEmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    daily.hour_of_day(18)
  end

  def perform
    TeamMember.where(deleted_at: nil, notify_by_email: true).each do |tm|
      person = tm.person
      project = tm.project
      sprint = project.sprints.current.first
      if sprint && sprint.sprint_elements.any?
        SprintMailer.summary_email(person, sprint).deliver_now
      end
    end
  end
end
