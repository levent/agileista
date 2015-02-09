module SprintsHelper
  def sprint_header(sprint)
    result = [%{#{h(sprint.name)}}]
    result << %{<small>#{show_date(sprint.start_at)} to #{show_date(sprint.end_at)}</small>}
    result.join(" ").html_safe
  end

  def average_velocity(project, opts = {})
    velocity = @velocity || project.average_velocity
    return nil unless velocity
    options = { unit: "story points" }.merge(opts)
    "#{velocity} #{options[:unit]}"
  end
end
