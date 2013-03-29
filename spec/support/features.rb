def login_a_user
  person = Person.make!
  person.confirm!
  login_as(person, :scope => :person)
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, :type => :feature
  Warden.test_mode!
  config.after(:each, :type => :feature) do
    Warden.test_reset!
  end
end
