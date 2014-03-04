class SlackWorker
  include Sidekiq::Worker

  def perform(team, token, channel, message = '')
    notifier = Slack::Notifier.new team, token
    notifier.ping Slack::Notifier::LinkFormatter.format(message), channel: "##{channel}"
  end
end
