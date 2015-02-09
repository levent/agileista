module UserStory
  class SprintPlannable
    def add_to_sprint(sprint)
      SprintElement.find_or_create_by(sprint_id: sprint.id, user_story_id: id)
      self.sprint = sprint
      save!
    end

    def remove_from_sprint(sprint)
      raise ArgumentError if sprint.nil?
      self.sprint = nil
      self.backlog_order_position = :first
      save!
      SprintElement.where(sprint_id: sprint.id, user_story_id: id).destroy_all
    end
  end
end
