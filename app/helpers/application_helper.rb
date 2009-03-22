# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end
  
  def account_switcher_selected(here, there)
    logger.info "here #{here}"
    logger.info "there #{there}"
    here == there ? "selected=\"selected\"" : ""
  end
  
  def show_stakeholder(user_story, show_creator = true)
    if !user_story.stakeholder.blank?
      return "#{user_story.stakeholder}"
    elsif user_story.person && show_creator
      "#{user_story.person.name}"
    else
      return "Unknown"
    end
  end
  
  def show_story_points(points, options = {:unit => "story point"})
    unit = options[:unit]
    unless points.nil?
      return pluralize(points, unit)
    else
      return "Undefined"
    end
  end

  def show_story_points_remaining(points)
    points.nil? ? (return "") : (return "(#{points} remaining)")
  end

  
  def select_date(date = Date.today, options = {})
    select_day(date, options) + select_month(date, options) + select_year(date, options)
  end
  
  def which_sprint(sprint)
    suffix = "sprint\""
    if sprint == @upcoming_sprint
      return "class=\"upcoming" + suffix
    elsif sprint == @current_sprint
      return "class=\"current" + suffix
    else
      return nil
    end
  end

  def show_hours_left(hours)
    unless hours.nil?
      return pluralize(hours, 'hour') + ' left'
    else
      return "Undefined"
    end
  end
  
  def show_assignee(developer)
    unless developer.nil?
      return developer.name
    else
      return "Nobody"
    end
  end

  def show_date(date)
    return date.strftime("%d %B %Y") 
  end
  
  def undefined?(userstory)
    if userstory.cannot_be_estimated?
      return " class=\"toovague\""
    elsif userstory.story_points.blank?
      userstory.acceptance_criteria.blank? ? (return " class=\"undefined nocrit\"") : (return " class=\"undefined\"")
    else
      return " class=\"defined\""
    end
  end
  
  # Tag cloud styler
  def build_tag_cloud(tag_cloud, style_list)
    max, min = 0, 0
    tag_cloud.each do |tag|
    max = tag.popularity.to_i if tag.popularity.to_i > max
    min = tag.popularity.to_i if tag.popularity.to_i < min
  end

  divisor = ((max - min) / style_list.size) + 1

  tag_cloud.each do |tag|
    yield tag.name, style_list[(tag.popularity.to_i - min) / divisor]
    end
  end

  # Create a link to a tag’s view page.
  # this could easily be different in your application, depending on how you structure your tag searches,
  # but it seems smart to include it here as my tag cloud code depends on it. Change the tag_item_url in
  def tag_item_url(name)
  "/backlog/search/#{name}"
  end
  
  def complete?(user_story)
    return ' class="uscomplete"' if user_story.complete?
  end
  
  def claimed?(user_story)
    return ' class="usclaimed"' if user_story.inprogress?
  end
  
  def claimed_or_complete?(user_story)
    return ' class="uscomplete"' if user_story.complete?
    return ' class="usclaimed"' if user_story.inprogress?
  end
  
  def unresolved_impediment_indicator(account)
    return "<span class=\"yellow\">*</span>" unless account.impediments.unresolved.blank?
  end
end