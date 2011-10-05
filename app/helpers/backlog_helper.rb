module BacklogHelper
  def release_marker(story_points, velocity)
    return '' unless velocity
    story_points.to_i >= velocity.to_i ? ' release_marker' : ''
  end
end
