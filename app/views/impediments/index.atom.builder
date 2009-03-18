atom_feed do |feed|
  feed.title("#{@account.name} impediments")
  feed.updated((@impediments.first.updated_at))
  if @impediments.any?
    @impediments.each do |impediment|
      feed.entry(impediment) do |entry|
        entry.title(impediment.description)
        entry.content(impediment.to_s, :type => 'html')
        entry.author do |author|
          author.name(impediment.team_member.name)
        end
      end
    end
  else
    feed.entry do |entry|
      entry.title("No Impediments")
      entry.content("...")
    end
  end
end