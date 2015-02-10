class CalculateBurnWorker
  include Sidekiq::Worker

  def perform(date, sprint_id)
    Burndown.generate!(Sprint.find(sprint_id), date)
  end
end
