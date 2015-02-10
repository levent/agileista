module UserStory::State
  # State on task board
  # TODO: Redo for clarity
  def status
    if inprogress?
      return "inprogress"
    elsif complete?
      return "complete"
    else
      return "incomplete"
    end
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
    if cannot_be_estimated?
      return 'clarify'
    elsif acceptance_criteria.blank?
      return 'criteria'
    elsif story_points.blank?
      return 'estimate'
    else
      return 'plan'
    end
  end
end
