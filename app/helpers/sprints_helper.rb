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
    options = {:show_date? => false, :show_story_points? => false, :buttons => []}.merge(options)

    if options[:buttons].any? && current_user.is_a?(TeamMember) && !sprint.finished?
      buttons = sprint_buttons(sprint, options[:buttons])
      result = [%{<span class="tab">#{sprint.name} #{buttons}</span>}]
    else
      result = [%{<span class="tab">#{sprint.name}</span>}]
    end

    result << %{<span class="hightlight">#{show_date(sprint.start_at)} to #{show_date(sprint.end_at)}.</span>} if options[:show_date?]
    result << %{<span class="hightlight"><strong>#{sprint.completed_story_points}</strong> out of <strong>#{sprint.total_story_points}</strong> story points completed</span>} if options[:show_story_points?] && !sprint.user_stories.blank?

    return result.join(" ")
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

  def average_velocity(sprints, opts = {})
    return nil unless sprints.length >= 2
    options = {:unit => "story points"}.merge(opts)

    if sprints.size == 0
      "0 #{options[:unit]}"
    else
      (sprints.finished.collect(&:calculated_velocity).sum / sprints.finished.size).to_s + " #{options[:unit]}"
    end
  end

  def state(item)
    if item.complete?
      "Complete"
    elsif item.inprogress?
      "In play"
    else
      "Incomplete"
    end
  end

  def user_story_actions(sprint, user_story)
    result = [link_to("Show", sprint_user_story_url(@sprint, user_story), :class => "button")]

    if current_user.is_a?(TeamMember) && !user_story.complete?
      result << link_to("Copy", copy_user_story_url(user_story), :method => :post, :class => "button")
      result << link_to("Remove", unplan_sprint_user_story_url(sprint, user_story), :method => :post, :class => "button")
    end

    return result.join(" ")
  end

  def task_actions(user_story, task)
    result = [link_to("Show", user_story_task_url(user_story, task), :class => "button")]

    if current_user.is_a?(TeamMember) && !user_story.complete?
      result << link_to("Edit", edit_user_story_task_url(user_story, task), :class => "button")
    end

    return result.join(" ")
  end
end

