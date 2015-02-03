module SpecHelpers
  module ModelsHelper
    def create_person
      person = Person.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "password", password_confirmation: "password")
      person.confirmed_at = Time.now
      person.save!
      person.reload
      person
    end

    def create_project
      Project.create!(name: Faker::Name.name, iteration_length: 2)
    end

    def create_sprint
      pr = create_project
      sprint = Sprint.new(name: Faker::Name.name, start_at: Time.now)
      sprint.project = pr
      sprint.save!
      sprint
    end

    def create_user_story
      project = create_project
      us = UserStory.new(definition: Faker::Lorem.sentence)
      us.project = project
      us.save!
      us
    end

    def create_acceptance_criterion(user_story = nil)
      us = user_story || create_user_story
      ac = AcceptanceCriterium.new(detail: Faker::Lorem.sentence)
      ac.user_story = us
      ac.save!
      ac
    end

    def create_task
      Task.create!(definition: Faker::Lorem.sentence)
    end
#    def create_user
#      User.create(email: 'user@brapp.com', name: 'Niki', password: 'testtest', password_confirmation: 'testtest')
#    end
#
#    def create_task_for(user)
#      user.tasks.create!(description: 'Finish writing this test')
#    end
#
#    def create_application
#      Doorkeeper::Application.create!(name: 'Test App', redirect_uri: 'https://oauth-callback')
#    end
#
#    def create_token(application, user)
#      Doorkeeper::AccessToken.create!(application: application, resource_owner_id: user.id)
#    end
  end
end
