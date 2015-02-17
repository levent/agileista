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
      indexes :tag, analyzer: 'keyword', as: 'tags'
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

      self.search({ "query": {
        "filtered": {
          "query": {
              "multi_match": {
                "query": search_query,
                "type": "cross_fields",
                "fields": [
                    "definition^3",
                    "description"
                ],
                "operator": "or"
              }
          },
          "filter": {
              "term": {
                "project_id": project_id
              }
            }
          }
        }
      })
    end
  end
end
