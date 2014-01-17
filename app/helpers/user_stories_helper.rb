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
      link = link_to m, project_search_path(@project, :q => "tag:#{tag.downcase}"), :class => 'tagged'
      definition.gsub!(m, link).html_safe
    end
    definition
  end

  def created_at_to_date(user_story)
    return underline('Today') if user_story.created_at.to_date == Date.today
    return underline('Yesterday') if user_story.created_at.to_date == Date.yesterday
    user_story.created_at.strftime("%d/%m/%y")
  end

  private

  def underline(whenever)
    content_tag :span, whenever, :class => 'underline'
  end
end
