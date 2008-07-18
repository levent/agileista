module UserStoriesHelper
  
  def show_completeness(bool)
    bool ? "Complete" : "Incomplete"
  end
  
end
