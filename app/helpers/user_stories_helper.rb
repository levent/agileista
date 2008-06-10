module UserStoriesHelper
  
  def show_user(user)
    return "Unknown" unless user
    user.name
  end
  
end
