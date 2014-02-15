module UserStoriesHelper

  def parse_definition(definition)
    definition = html_escape(definition)
    definition.scan(/\[\w+\]/).uniq.each do |m|
      tag = m.clone
      tag.gsub!('[', '').gsub!(']', '')
      link = link_to m, project_search_path(@project, :q => "tag:#{tag.downcase}"), :class => 'tagged'
      definition.gsub!(m, link).html_safe
    end
    definition
  end
end
