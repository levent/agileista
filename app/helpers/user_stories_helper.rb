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
  
  def user_story_status(user_story)
    return "Cannot be estimated" if user_story.cannot_be_estimated?
    return "Unestimated" if user_story.story_points.blank?
    return "OK"
  end
end

# def undefined?(userstory)
#   if userstory.cannot_be_estimated?
#     return " class=\"toovague\""
#   elsif userstory.story_points.blank?
#     userstory.acceptance_criteria.blank? ? (return " class=\"undefined nocrit\"") : (return " class=\"undefined\"")
#   else
#     return " class=\"defined\""
#   end
# end
