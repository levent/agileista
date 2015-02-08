module UserStory::State

  # State on task board
  # TODO: Redo for clarity
  def status
    cached_status = REDIS.get("user_story:#{self.id}:status")
    unless cached_status
      if self.inprogress?
        cached_status = "inprogress"
      elsif self.complete?
        cached_status = "complete"
      else
        cached_status = "incomplete"
      end
      REDIS.set("user_story:#{self.id}:status", cached_status)
      REDIS.expire("user_story:#{self.id}:status", REDIS_EXPIRY)
    end
    cached_status
  end

  def inprogress?
    if !tasks.blank?
      tasks.each do |task|
        return true if task.inprogress?
      end
      return false
    else
      return false
    end
  end

  def complete?
    if !tasks.blank?
      tasks.each do |task|
        return false unless task.done?
      end
      return true
    else
      return false
    end
  end

  # State on backlog
  # TODO: Redo for clarity
  def state
    cached_state = REDIS.get("user_story:#{self.id}:state")
    unless cached_state
      if self.cannot_be_estimated?
        cached_state = 'clarify'
      elsif self.acceptance_criteria.blank?
        cached_state = 'criteria'
      elsif self.story_points.blank?
        cached_state = 'estimate'
      else
        cached_state = 'plan'
      end
      REDIS.set("user_story:#{self.id}:state", cached_state)
      REDIS.expire("user_story:#{self.id}:state", REDIS_EXPIRY)
    end
    cached_state
  end

  private

  def expire_status
    REDIS.del("user_story:#{self.id}:status")
  end

  def expire_state
    REDIS.del("user_story:#{self.id}:state")
  end

  def expire_story_points
    REDIS.del("project:#{self.project.id}:story_points")
  end
end
