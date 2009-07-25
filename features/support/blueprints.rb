require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.name  { Faker::Name.name }
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
end

Burndown.blueprint do
  hours_left { rand(100) }
  sprint_id { rand(100) }
end