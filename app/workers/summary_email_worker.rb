class SummaryEmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    daily.hour_of_day(18)

    daily.hour_of_day(11)
  end

  def perform
    person = Person.find_by(email: 'lebreeze@gmail.com')
    project = Project.find(132)
    sprint = project.sprints.current.first
    if sprint
      SprintMailer.summary_email(person, sprint).deliver
    end
  end
end
