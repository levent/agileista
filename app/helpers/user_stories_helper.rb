module UserStoriesHelper
  def parse_definition(definition, project)
    definition = html_escape(definition)
    definition.scan(/\[\w+\]/).uniq.each do |m|
      tag = m.clone
      tag.gsub!('[', '').gsub!(']', '')
      m == '[APPROVED]' ? link_text = "[<span class=\"highlight-green\">#{tag}</span>]".html_safe : link_text = m
      link = link_to link_text, project_search_path(project, q: "tag:#{tag.downcase}"), class: 'tagged'
      definition.gsub!(m, link).html_safe
    end
    definition
  end
end
