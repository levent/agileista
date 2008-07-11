module ImpedimentsHelper
  def complete?(impediment)
    return ' class="complete"' if impediment.resolved_at
  end
end
