module UserStoriesHelper

  def show_user(user_story)
    if user_story.person
      return "by #{user_story.person.name}"
    else
      return "by Unknown"
    end
  end
  
  def show_completeness(bool)
    bool ? "Complete" : "Incomplete"
  end
  
end
