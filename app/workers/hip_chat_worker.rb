class HipChatWorker
  include Sidekiq::Worker

  def perform(api_token, room, notify = false, message = '')
    client = HipChat::Client.new(api_token)
    client[room].send('Agileista', message, color: 'purple', notify: notify)
  end
end
