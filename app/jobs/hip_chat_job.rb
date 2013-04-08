class HipChatJob
  @queue = :hip_chat

  def self.perform(api_token, room, notify, message)
    client = HipChat::Client.new(api_token)
    client[room].send('Agileista', message, :color => 'purple', :notify => notify)
  end
end
