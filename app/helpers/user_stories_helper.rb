module UserStoriesHelper
  
  def show_user(user)
    return "Unknown" unless user
    user.name
  end
  
  def show_completeness(bool)
    bool ? "Complete" : "Incomplete"
  end
  
end
