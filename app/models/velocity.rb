class Velocity

  def self.stats_significant_since(project)
    REDIS.get("project:#{project.id}:stats_since") || project.sprints.finished.last.try(:start_at) || Time.now
  end

  def self.stats_significant_since_sprint_id(project_id)
    REDIS.get("project:#{project_id}:stats_since:sprint_id")
  end

  def self.confidence_interval(story_points = [])
    return if story_points.size < 5
    [calculate_confidence(story_points, '-'), calculate_confidence(story_points, '+')]
  end

  def self.calculate_confidence(story_points = [], hi_or_lo)
    story_points.sort!
    interval = REDIS.get(story_points.join(hi_or_lo))
    unless interval
      position = (story_points.size / 2).send(hi_or_lo, (1.96 * (story_points.size * 0.25)**0.5))
      interval = story_points[position.ceil - 1]
      REDIS.set(story_points.join(hi_or_lo), interval)
    end
    interval
  end
end
