require 'machinist/active_record'
require 'faker'

Account.blueprint do
  account_holder  { Person.make }
  name { Faker::Name.name }
  subdomain   { Faker::Internet.domain_word }
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
  account { Account.make }
end

Burndown.blueprint do
  hours_left { rand(100) }
  sprint { Sprint.make }
end

Theme.blueprint do
  name { Faker::Name.name }
end

UserStory.blueprint do
  account { Account.make }
  definition { Faker::Lorem.sentence }
end

Task.blueprint do
  definition { Faker::Lorem.sentence }
  hours { rand(12) }
end

AcceptanceCriterium.blueprint do
  detail { Faker::Lorem.sentence }
end
