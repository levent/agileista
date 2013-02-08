module SprintsHelper
  def identify_key_sprint(sprint)
    if sprint.current?
      " currentsprint"
    elsif sprint.upcoming?
      " upcomingsprint"
    else
      ""
    end
  end

  def sprint_header(sprint, options = {})
    result = [%{#{sprint.name}}]
    result << %{<small>#{show_date(sprint.start_at)} to #{show_date(sprint.end_at)}</small>}

    return result.join(" ").html_safe
  end

  def average_velocity(account, opts = {})
    return nil unless velocity = @velocity || account.average_velocity
    options = {:unit => "story points"}.merge(opts)
    "#{velocity} #{options[:unit]}"
  end

end

