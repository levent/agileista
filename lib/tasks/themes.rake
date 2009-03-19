namespace :themes do
  namespace :order do
    desc "Sets themes in alphabetical order"
    task(:name => :environment) do
      Account.all.each do |account|
        p "Account: #{account.name}"
        position = 0
        account.themes.each do |t|
          position += 1
          p "#{position}. #{t.id} unordered -- #{t.name}"
        end
        position = 0
        account.themes.all(:order => "name").each do |t|
          position += 1
          t.position = position
          if t.save
            p "#{position}. #{t.id} saved -- #{t.name}"
          else
            p "#{position}. #{t.id} couldn't be saved -- #{t.name}"
          end
        end
        p "-------------"
      end
    end
  end
end
