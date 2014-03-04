class BossWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: true do
    hourly(6)
  end

  def perform(last_occurrence, current_occurrence)
    boss = Person.find_by(email: 'lebreeze@gmail.com')
    boss.team_members.where(deleted_at: nil, notify_by_email: true).each do |tm|
      project = tm.project
      sprint = project.sprints.current.first
      if sprint
        SprintMailer.summary_email(boss, sprint).deliver
      end
    end
  end
end
