atom_feed do |feed|
  feed.title("#{@account.name} impediments")
  @impediments.any? ? feed.updated((@impediments.first.updated_at)) : feed.updated(Time.now)
  @impediments.each do |impediment|
    feed.entry(impediment) do |entry|
      entry.title(impediment.description)
      entry.content(impediment.to_s, :type => 'html')
      entry.author do |author|
        author.name(impediment.team_member.name)
      end
    end
  end
end