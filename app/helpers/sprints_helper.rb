module SprintsHelper
  def identify_key_sprint(sprint)
    return "class=\"currentsprint\"" if sprint.current?
    return "class=\"upcomingsprint\"" if sprint.upcoming?
    return ""
  end
end