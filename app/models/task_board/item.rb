# Represents a user story and its three types of tasks on a task board
class TaskBoard::Item
  attr_accessor :user_story

  def initialize(user_story)
    @user_story = user_story
    @tasks = @user_story.tasks
  end

  def available_tasks
    filter_for_available
  end

  def inprogress_tasks
    filter_for_inprogress
  end

  def complete_tasks
    filter_for_complete
  end

  private

  def without_complete_tasks
    @tasks.to_a.delete_if { |t| t.done == true }
  end

  def filter_for_available
    without_complete_tasks.select { |x| x.assignees.blank? }
  end

  def filter_for_inprogress
    without_complete_tasks.select { |x| x.assignees.present? }
  end

  def filter_for_complete
    @tasks.to_a.delete_if { |t| t.done == false }
  end
end
