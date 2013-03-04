require 'machinist/active_record'
require 'faker'

Invitation.blueprint do
  email { Faker::Internet.email }
  project { Project.make }
end

Project.blueprint do
  name { Faker::Name.name }
  iteration_length { 2 }
end

Person.blueprint do
  name {Faker::Name.name}
  email {Faker::Internet.email}
  password { "password" }
  password_confirmation { "password" }
end

Sprint.blueprint do
  name { Faker::Name.name }
  start_at { 1.weeks.ago }
  end_at { 1.weeks.from_now }
  project { Project.make }
end

Burndown.blueprint do
  hours_left { rand(100) }
  sprint { Sprint.make }
end

UserStory.blueprint do
  project { Project.make }
  definition { Faker::Lorem.sentence }
end

Task.blueprint do
  definition { Faker::Lorem.sentence }
  hours { rand(12) }
end

AcceptanceCriterium.blueprint do
  detail { Faker::Lorem.sentence }
end

SprintElement.blueprint do
  user_story { UserStory.make }
  sprint { Sprint.make }
end
