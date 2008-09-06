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
      test_mode = true
      if ENV['TEST_MODE'].nil?
        test_mode = true
      else
        test_mode = false
      end
      Account.all.each do |account|
        account.people.each do |person|
          if person.authenticated?
            p "mailing #{account.name}'s #{person.name}"
            if test_mode
              if %w(lebreeze@gmail.com levent.ali@jgp.co.uk levent@leventali.com).include?(person.email)
                NotificationMailer.deliver_account_information(person, account)
                p "sent in test mode"
              else
                p "not sent in test mode"
              end
            else            
              NotificationMailer.deliver_account_information(person, account)
              p "sent in production mode"
            end
            p "done..."
            puts
            puts
          end
        end
      end
    end
  end
end
