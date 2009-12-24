module ImpedimentsHelper
  def impediment_complete?(impediment)
    return ' class="complete"' if impediment.resolved_at
  end

  def show_resolved_at(impediment)
    if impediment.resolved_at
      return "#{time_ago_in_words(impediment.resolved_at)} ago"
    else
      link_to 'Resolve', resolve_impediment_path(:id => impediment, :page => params[:page]), :method => :post, :class => "button"
    end
  end

  def current_view(action)
    params[:action] == action ? "highlight" : nil
  end

  def impediment_feed(action)
    return auto_discovery_link_tag(:atom, active_impediments_path(:format => :atom)) if action == "active"
    return auto_discovery_link_tag(:atom, impediments_path(:format => :atom)) if action == "index"
  end
end

