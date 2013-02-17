namespace :account do

  desc "Migrate accounts to projects"
  task :to_project => :environment do
    UserStory.suspended_delta do
      Project.destroy_all
      Account.all.each do |account|
        puts "Creating project #{account.name} from account ##{account.id}"
        project = Project.create!(:name => account.name, :iteration_length => (account.iteration_length || 4), :velocity => account.velocity)
        account.people.each do |person|
          matching_people = Person.find_all_by_email(person.email)
          puts "Project: #{project.name} gaining #{matching_people.count} people"
          project.people << matching_people
          puts "Project: #{project.name} gaining #{account.user_stories.count} stories"
          project.user_stories << account.user_stories
          puts "Project: #{project.name} gaining #{account.sprints.count} sprints"
          project.sprints << account.sprints
          scrum_master = account.account_holder.email
          puts "#{project.name} scrum master is #{scrum_master}"
          REDIS.set("project:#{project.id}:scrum_master", scrum_master)
        end
      end
      emails = Hash.new(0)
      Person.all.collect(&:email).each do |email|
        emails[email] += 1
      end
      emails.select {|k,v| v > 1}.each do |email_counts|
        email = email_counts[0]
        people = Person.where("email = ?", email)
        puts "Getting primary for #{email}"
        primary = REDIS.get("person:#{email}:primary")
        unless primary
          primary = people.last.id
          puts "Setting primary for #{email}"
          REDIS.set("person:#{email}:primary", primary)
        end
        puts "Primary for #{email} is #{primary}"

        primary_person = people.find(primary)
        people.each do |person|
          unless person == primary_person
            puts "Moving user_stories from #{person.id} to #{primary}"
            primary_person.user_stories << person.user_stories
            puts "Moving tasks from #{person.id} to #{primary}"
            primary_person.tasks << person.tasks
            puts "Deleting #{person.id}"
            person.destroy
          end
        end
      end
      Project.all.each do |project|
        scrum_master = REDIS.get("project:#{project.id}:scrum_master")
        person = project.people.find_by_email(scrum_master)
        if scrum_master && person
          tm = TeamMember.find_by_project_id_and_person_id(project.id, person.id)
          puts "Project #{project.name} scrum master is *drum roll* #{scrum_master}"
          tm.update_attribute(:scrum_master, true)
        else
          puts "Project #{project.name} has gone rogue. Scrum master should be #{scrum_master}"
        end
      end
    end
  end

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
