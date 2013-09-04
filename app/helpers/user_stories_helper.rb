module UserStoriesHelper

  def show_user(user_story)
    if user_story.person
      return "by #{user_story.person.name}"
    else
      return "by Unknown"
    end
  end

  def user_story_status(user_story)
    return "Cannot be estimated" if user_story.cannot_be_estimated?
    return "Unestimated" if user_story.story_points.blank?
    return "OK"
  end

  def parse_definition(definition)
    definition = html_escape(definition)
    definition.scan(/\[\w+\]/).uniq.each do |m|
      tag = m.clone
      tag.gsub!('[', '').gsub!(']', '')
      link = link_to m, search_project_backlog_index_path(@project, :q => "tag:#{tag.downcase}"), :class => 'tagged'
      definition.gsub!(m, link).html_safe
    end
    definition
  end
end
