namespace :account do
  desc "Downcase email address for postgres"
  task :downcase_emails => :environment do
    Person.all.each do |person|
      if person.email.downcase != person.email
        puts person.email
        person.update_attribute(:email, person.email.downcase)
      end
    end
  end

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
