module FeatureHelpers
  def login_a_user
    person = Person.make!
    person.confirm!
    login_as(person, :scope => :person)
    person
  end

  def create_project_for(person)
    project = Project.make!
    person.projects << project
    project.scrum_master = person
    project.save!
    project
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, :type => :feature
  config.include FeatureHelpers, :type => :feature
  Warden.test_mode!
  config.after(:each, :type => :feature) do
    Warden.test_reset!
  end
end
