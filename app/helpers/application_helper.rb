# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end

  def account_switcher_selected(here, there)
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

  def show_story_points(points, opts = {})
    options = {:unit => "story point"}.merge(opts)
    points = points.nil? ? "0" : points

    return pluralize(points, options[:unit])
  end

  def show_story_points_remaining(points)
    return points.nil? ? "" : "(#{points} remaining)"
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
  
  def show_assignees(developers)
    if developers.any?
      return developers.map(&:name).join(', ')
    else
      return "Nobody"
    end
  end

  def show_date(date)
    return date.strftime("%d %B %Y")
  end

  def show_date_and_time(date)
    return date.strftime("%d %b %y %H:%M %p")
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

  def page_signature(params_hash = params)
    result = [params_hash[:controller], params_hash[:action]]

    result << "backlog" if ["user_stories"].include?(params_hash[:controller])
    result << "authenticated" if current_user
    result << "contributor" if current_user.is_a?(Contributor)
    result << "task_board" if current_sprint && (params_hash[:controller] == "sprints" && params_hash[:action] == "show" && params_hash[:id].to_i == current_sprint.id)

    return result.join(" ")
  end

  def create_new_account?
    return ' <span class="new_account"' + link_to('Create a new account', {:controller => 'signup'}) + '</span>' if current_subdomain == AccountStuff::MASTER_SUBDOMAIN
  end

  def flash_messages(wrapper = "h3")
    messages = []
    messages << "notice" if flash.has_key?("notice".to_sym)
    messages << "error" if flash.has_key?("error".to_sym)

    if messages.size > 0
      result = []
      result << %{<!-- flash messages >>> -->\n<div class="flash">}
      messages.each do |message|
        result << content_tag(wrapper.to_sym, flash[message.to_sym], :class => "message #{message}")
      end
      result << "</div>\n<!-- <<< messages -->"

      return result.join("\n")
    end
  end

  def main_navigation
    result = []
    [ {:name => "backlog", :url => {:controller => "backlog"}},
      {:name => "themes", :url => themes_url},
      {:name => "sprints", :url => sprints_url},
      {:name => "impediments", :url => impediments_url, :class => unresolved_impediment_indicator(@account)},
      ({:name => "task board", :url => sprint_url(current_sprint), :match => "task_board"} if current_sprint)
    ].each do |link|
      if link
        result << build_link(link)
      end
    end

    return content_tag(:ul, result.join("\t\n"))
  end

  def user_navigation
    result = []
    [ {:name => "account", :url => {:controller => "account", :action => "settings"}, :match => ["account", "users"]},
      {:name => "logout", :url => {:controller => "login", :action => "logout"}}
    ].each do |link|
      if link
        result << build_link(link)
      end
    end

    return content_tag(:ul, result.join("\t\n"))
  end

  def add_user_story
    if current_user.is_a?(Contributor)
      link_to "Add user story", :controller => 'user_stories', :action => "add"
    elsif current_user.is_a?(TeamMember)
      link_to "Add user story", :controller => 'user_stories', :action => "new"
    end
  end

  def display_themes(account, current_themes)
    result = []

    account.themes.collect do |theme|
      checkbox = check_box_tag("user_story[theme_ids][]", theme.id, (true if current_themes.include?(theme)), :id => sanitize_to_id(theme.name), :class => "checkbox")
      label = label_tag(theme.name, nil, :class => "checkbox")

      result << "<div>#{checkbox} #{label}</div>"
    end

    return result.join("\n")
  end

  def confirmation_message(object, name)
    "This cannot be undone. Are you sure you want to delete #{object} '#{name}'?"
  end

  def user_story_state(state)
    %[<span class="#{state}">#{state.titleize}</span>]
  end

  def pagination_info(entries, name = "entries")
    "<strong class=\"hightlight\">#{number_with_delimiter(entries.offset + 1)} - #{number_with_delimiter(entries.offset + entries.length)}</strong> of <strong>#{pluralize(content_tag(:strong, number_with_delimiter(entries.total_entries)), name)}</strong>" if entries
  end


  protected

  def build_link(link)
    match = link[:match] || link[:name]
    content_tag(
      :li,
      link_to(
        link[:name].titleize,
        link[:url],
        ({:class => link[:class]} if link[:class])
      ),
      :class => "#{link[:name].gsub(/\s/, '_')}#{' active' if active?(match)}"
    )
  end

  def active?(match)
    if match.is_a?(Array)
      match.any? {|match| page_signature.include?(match)}
    else
      page_signature.include?(match)
    end
  end

  def unresolved_impediment_indicator(account)
    account.impediments.unresolved.blank? ? "resolved" : "unresolved"
  end

  def current_sprint
    @account.sprints.current.first if @account
  end
end

