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

  def sprint_buttons(sprint, buttons = [])
    result = []

    if buttons.any?
      result << link_to("Edit", edit_sprint_url(sprint), :class => "button") if buttons.include?(:edit)
      result << link_to("Plan", edit_sprint_url(sprint), :class => "button") if buttons.include?(:plan)
      result << link_to("Add story", new_sprint_user_story_url(sprint), :class => "button") if buttons.include?(:add_story)
    end

    return result.join(" ") if result.any?
  end

  def average_velocity(account, opts = {})
    return nil unless velocity = @velocity || account.average_velocity
    options = {:unit => "story points"}.merge(opts)
    "#{velocity} #{options[:unit]}"
  end

end

