module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :id, index: :not_analyzed
      indexes :definition, analyzer: 'snowball', boost: 100
      indexes :description, analyzer: 'snowball', boost: 50
      indexes :stakeholder, analyzer: 'simple'
      indexes :story_points, type: 'integer', index: :not_analyzed
      indexes :project_id, type: 'integer', index: :not_analyzed
      indexes :sprint_id, type: 'integer', index: :not_analyzed
      indexes :created_at, type: 'date', include_in_all: false
      indexes :tags, analyzer: 'keyword', as: 'tags'
      indexes :search_ac, analyzer: 'snowball', as: 'search_ac'
      indexes :search_task, analyzer: 'snowball', as: 'search_tasks'
      indexes :state, analyzer: 'keyword', as: 'state'
    end

    # def self.search_by_query(search_query, page, project_id, all_sprints = false)
    #   raise ArgumentError unless project_id
    #   search(per_page: 100, page: page, load: true) do |search|
    #     search.query do |query|
    #       query.filtered do |f|
    #         f.query do |q|
    #           q.string search_query, default_operator: "AND"
    #         end
    #         f.filter :missing, field: :sprint_id unless all_sprints
    #         f.filter :term, project_id: project_id
    #       end
    #     end
    #     search.facet('tags') do
    #       terms :tag
    #     end
    #   end
    # end
    def self.search_by_query(search_query, page, project_id, all_sprints = false)
      raise ArgumentError unless project_id
      self.search({"query"=>{"filtered"=>{"query"=>{"query_string"=>{"query"=>search_query, "default_operator"=>"AND"}}, "filter"=>{"and"=>[{"missing"=>{"field"=>"sprint_id"}}, {"term"=>{"project_id"=>project_id}}]}}}, "facets"=>{"tags"=>{"terms"=>{"field"=>"tags", "size"=>10, "all_terms"=>false}}}, "size"=>100})
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

    def as_indexed_json(options = {})
      byebug
      puts 'byebug'
      as_json(methods: :tags)

    end
  end
end
