require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.name  { Faker::Name.name }
Sham.sentence { Faker::Lorem.sentence }
Sham.email { Faker::Internet.email }
Sham.subdomain { Faker::Internet.domain_word }


Account.blueprint do
  account_holder  { TeamMember.make }
  name { Sham.name }
  subdomain   { Sham.subdomain }
  iteration_length { 2 }
end

TeamMember.blueprint do
  name {Sham.name}
  email {Sham.email}
  password { "password" }
  password_confirmation { "password" }
end

Sprint.blueprint do
  name { Sham.name }
  start_at { 1.weeks.ago }
  end_at { 1.weeks.from_now }
  account { Account.make }
end

Burndown.blueprint do
  hours_left { rand(100) }
  sprint_id { rand(100) }
end

Theme.blueprint do
  name { Sham.name }
end

UserStory.blueprint do
  account { Account.make }
  definition { Sham.sentence }
end

Task.blueprint do
  definition { Sham.sentence }
  hours { rand(12) }
end