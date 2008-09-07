module ImpedimentsHelper
  def impediment_complete?(impediment)
    return ' class="complete"' if impediment.resolved_at
  end
  
  def show_resolved_at(impediment)
    if impediment.resolved_at
      return "#{time_ago_in_words(impediment.resolved_at)} ago"
    else
      link_to('Resolve', resolve_impediment_path(:id => impediment), :method => :post)
    end
  end
end
