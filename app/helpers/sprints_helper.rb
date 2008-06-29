module SprintsHelper
  def identify_key_sprint(sprint)
    return "class=\"currentsprint\"" if sprint.current?
    return "class=\"upcomingsprint\"" if sprint.upcoming?
    return ""
  end
  
  def sprint_header(sprint)
    # <h1><%=h @sprint.name %> - <span class="small"><%= show_date(@sprint.start_at) %> to <%= show_date(@sprint.end_at) %> (<%= pluralize(@sprint.hours_left, 'hour') %> left)</span></h1>
    "#{@sprint.name} - <span class=\"small\">#{show_date(@sprint.start_at)} to #{show_date(@sprint.end_at)} (#{pluralize(@sprint.hours_left, 'hour')} left)</span>"
  end
end