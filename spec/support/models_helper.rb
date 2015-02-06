module SpecHelpers
  module ModelsHelper
    def create_person
      person = Person.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "password", password_confirmation: "password")
      person.confirmed_at = Time.now
      person.save!
      person.reload
      person
    end

    def create_project(user = nil)
      project = Project.create!(name: Faker::Name.name, iteration_length: 2)
      if user
        project.scrum_master = user
        project.save!
      end
      project
    end

    def create_sprint(project = nil)
      pr = project || create_project
      sprint = Sprint.new(name: Faker::Name.name, start_at: Time.now)
      sprint.project = pr
      sprint.save!
      sprint
    end

    def create_user_story(project = nil)
      prj = project || create_project
      us = UserStory.new(definition: Faker::Lorem.sentence)
      us.project = prj
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
      Task.create!(definition: Faker::Lorem.sentence, user_story: create_user_story)
    end

    def assign_user_story_to_sprint(user_story, sprint)
      user_story.sprint = sprint
      user_story.save!
      SprintElement.create!(sprint_id: sprint.id, user_story_id: user_story.id)
    end
  end
end
