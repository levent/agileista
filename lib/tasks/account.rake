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
    
    desc "Informs all users on the new url structure"
    task(:notify => :environment) do
      Account.all.each do |account|
        account.people.each do |person|
          if person.authenticated?
            p "mailing #{account.name}'s #{person.name}"
            NotificationMailer.deliver_account_information(person, account)
            p "done..."
            puts
          end
        end
      end
    end
  end
end
