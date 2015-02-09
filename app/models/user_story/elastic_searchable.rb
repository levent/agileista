module UserStory::ElasticSearchable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def search_by_query(search_query, page, project_id, all_sprints = false)
      raise ArgumentError unless project_id
      search(per_page: 100, page: page, load: true) do |search|
        search.query do |query|
          query.filtered do |f|
            f.query do |q|
              q.string search_query, default_operator: "AND"
            end
            f.filter :missing, field: :sprint_id unless all_sprints
            f.filter :term, project_id: project_id
          end
        end
        search.facet('tags') do
          terms :tag
        end
      end
    end
  end

  def search_ac
    acceptance_criteria.collect(&:detail)
  end

  def search_tasks
    tasks.collect(&:definition)
  end

  def tags
    definition.scan(/\[(\w+)\]/).uniq.flatten.map(&:downcase)
  end
end
