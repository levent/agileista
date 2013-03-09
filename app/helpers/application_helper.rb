# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def scrum_master?
    return false unless @project && current_person
    current_person.scrum_master_for?(@project)
  end

  def current_user
    current_person
  end

  def show_stakeholder(user_story)
    if !user_story.stakeholder.blank?
      return "#{user_story.stakeholder}"
    elsif user_story.person
      "#{user_story.person.name}"
    else
      return "Unknown"
    end
  end

  def show_story_points(points, opts = {})
    options = {:unit => "story point"}.merge(opts)
    css_class = ['label', 'round', 'points']
    if points.nil?
      points = '?'
      css_class << 'secondary'
    end
    output = pluralize(points, options[:unit])

    if options[:badge]
      content_tag :span, :class => css_class.join(' ') do
        output
      end
    else
      output
    end
  end

  def show_assignees(developers)
    if developers.any?
      return developers.map(&:name).join(', ')
    else
      return "Nobody"
    end
  end

  def show_date(date)
    date.strftime("%d %B %Y")
  end

  def show_date_and_time(date)
    date.strftime("%d %b %y %H:%M %p")
  end

  def user_story_state(state)
    mapping = {
      :clarify => '',
      :criteria => 'alert',
      :estimate => 'secondary',
      :plan => 'success'
    }
    %[<span class="label #{mapping[state.to_sym]} fixed-width-label">#{state.titleize}</span>].html_safe
  end

  def pagination_info(entries, name = "entries")
    "<strong class=\"hightlight\">#{number_with_delimiter(entries.offset + 1)} - #{number_with_delimiter(entries.offset + entries.length)}</strong> of <strong>#{pluralize(content_tag(:strong, number_with_delimiter(entries.total_entries)), name)}</strong>" if entries
  end

  protected

  def current_sprint
    @current_sprint ||= @project.sprints.current.first if @project
  end
end

