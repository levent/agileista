class TaskBoardNotification
  attr_reader :task
  attr_reader :person
  attr_accessor :payload

  class Payload
    attr_reader :notification
    def initialize(notification, notification_hash)
      @notification = notification
      notification.payload = notification_hash.to_json
    end

    def publish
      REDIS.publish(redis_key, notification.payload)
    end

    def redis_key
      "pubsub." + Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{notification.task.user_story.sprint_id}")
    end
  end

  def initialize(task, person)
    @task = task
    @person = person
  end

  def created
    Payload.new(self, { performed_by: person.name, refresh: true })
  end
end

