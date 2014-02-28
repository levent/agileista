class SummaryEmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    daily.hour_of_day(18)

    daily.hour_of_day(11)
  end

  def perform
    TeamMember.where(deleted_at: nil, notify_by_email: true).each do |tm|
      person = tm.person
      project = tm.project
      sprint = project.sprints.current.first
      if sprint
        SprintMailer.summary_email(person, sprint).deliver
      end
    end
  end
end
