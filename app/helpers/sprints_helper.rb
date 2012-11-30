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
    options = {:buttons => []}.merge(options)

    if options[:buttons].any? && !sprint.finished?
      buttons = sprint_buttons(sprint, options[:buttons])
      result = [%{<span class="tab">#{sprint.name} #{buttons}</span>}]
    else
      result = [%{<span class="tab">#{sprint.name}</span>}]
    end
    result << %{<span class="hightlight">#{show_date(sprint.start_at)} to #{show_date(sprint.end_at)}</span>}
    result << %{<span class="hightlight"><strong id="current_complete"></strong> out of <strong id="current_total">#{sprint.total_story_points}</strong> story points completed (<strong id="current_percentage"></strong>)</span>} unless sprint.user_stories.blank?

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

  def user_story_actions(sprint, user_story)
    result = [link_to("Show", sprint_user_story_url(@sprint, user_story), :class => "button")]

    if !user_story.complete?
      result << link_to("Copy", copy_user_story_url(user_story), :method => :post, :class => "button")
      result << link_to("Remove", unplan_sprint_user_story_url(sprint, user_story), :method => :post, :class => "button")
    end

    return result.join(" ")
  end

  def task_actions(user_story, task)
    result = [link_to("Show", user_story_task_url(user_story, task), :class => "button")]

    if !user_story.complete?
      result << link_to("Edit", edit_user_story_task_url(user_story, task), :class => "button")
    end

    return result.join(" ")
  end
end

