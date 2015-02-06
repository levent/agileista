class TaskBoardNotification
  attr_reader :user_story
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
      sprint_id = notification.user_story.sprint_id
      "pubsub." + Digest::SHA256.hexdigest("#{Agileista::Application.config.sse_token}sprint#{sprint_id}")
    end
  end

  def initialize(user_story, task, person)
    @task = task
    @user_story = user_story || task.user_story
    @person = person
  end

  def refresh
    Payload.new(self, { performed_by: person.name, refresh: true })
  end

  def create
    setup_payload(:create, true)
  end

  def renounce
    setup_payload(:renounce)
  end

  def claim
    setup_payload(:claim)
  end

  def complete
    setup_payload(:complete)
  end

  private

    def devs
      task.assignees.split(',')
    end

    def setup_payload(message_type, refresh = false)
      word_mapping = {
        complete: 'completed',
        claim: 'claimed',
        renounce: 'renounced',
        create: 'created'
      }
      Payload.new(self, { notification: "#{person.name} #{word_mapping[message_type]} task of ##{task.user_story_id}", performed_by: person.name, action: message_type.to_s, task_id: task.id, task_hours: task.hours, task_devs: devs, user_story_status: task.user_story.status, user_story_id: task.user_story_id, refresh: refresh })
    end
end

