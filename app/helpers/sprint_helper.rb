module SprintHelper
  
  def complete?(user_story)
    return ' class="uscomplete"' if user_story.complete?
  end
  
end
