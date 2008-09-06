namespace :account do
  namespace :subdomains do
    desc "Sets blank subdomains to account name conversion"
    task(:set => :environment) do
      Account.all.each do |account|
        if account.subdomain.blank?
          puts "Account #{account.id} being processed..."
          puts "name: #{account.name}"
          account.subdomain = account.name.gsub(' ', '-').gsub('_', '-')
          puts "attempting subdomain: #{account.subdomain}"
          if account.save
            puts "Account #{account.id} successful"
          else
            puts "Account #{account.id} failed"
            puts "#{account.errors.full_messages}"
          end
        end
      end
    end
  end
end
