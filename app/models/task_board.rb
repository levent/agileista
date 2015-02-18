class TaskBoard
  def initialize(sprint)
    @sprint = sprint
  end

  def items
    @items ||= @sprint.user_stories.collect { |us| TaskBoard::Item.new(us) }
  end
end
