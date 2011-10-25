module UserStoriesHelper

  def show_themes(themes)
    if themes.blank?
      "Not assigned to any themes"
    else
      result = []
      themes.each {|t| result << h(t.name)}
      result.join(", ")
    end
  end

  def show_tags(tags)
    if tags.blank?
      "No tags"
    else
      result = []
      tags.each do |tag|
        result << link_to(tag[:name], {:controller => 'backlog', :action => 'search', :q => tag[:name]}, :method => :post)
      end
    end
  end

  def show_user(user_story)
    if user_story.person
      return "by #{user_story.person.name}"
    else
      return "by Unknown"
    end
  end

  def show_completeness(bool)
    bool ? "Complete" : "Incomplete"
  end

  def user_story_status(user_story)
    return "Cannot be estimated" if user_story.cannot_be_estimated?
    return "Unestimated" if user_story.story_points.blank?
    return "OK"
  end

  def show_link(user_story)
    if user_story.sprint
      sprint_user_story_url(user_story.sprint, user_story)
    else
      user_story_url(user_story)
    end
  end

  def edit_link(user_story)
    if user_story.sprint
      edit_sprint_user_story_url(user_story.sprint, user_story)
    else
      edit_user_story_url(user_story)
    end
  end

  def parse_definition(definition)
    definition.scan(/\[\w+\]/).uniq.each do |m|
      link = link_to m, search_backlog_path(:q => m)
      definition.gsub!(m, link).html_safe
    end
    definition.html_safe
  end
end

