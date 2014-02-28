class SummaryEmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    person = Person.find_by(email: 'lebreeze@gmail.com')
    project = Project.find(132)
    sprint = project.sprints.current.first
    if sprint
      SprintMailer.summary_email(person, sprint).deliver
    end
  end
end
