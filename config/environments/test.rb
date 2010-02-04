ActiveRecord::Base
# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
ActionController::Base.session_options[:session_domain] = 'agileista.local'

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
# config.gem "rspec", :lib => false, :version => "1.2.9"
# config.gem "rspec-rails", :lib => false, :version => "1.2.9"
# # config.gem "cucumber"
# # config.gem "brynary-webrat", :lib => 'webrat', :source => 'http://gems.github.com'
# # config.gem "webrat"
# config.gem "notahat-machinist", :lib => false, :source => "http://gems.github.com"
# config.gem "faker", :lib => false
# config.gem "drnic-blue-ridge", :lib => false, :source => "http://gems.github.com"

EMAIL_FROM = "donotreply@agileista.purebreeze.com"

config.after_initialize do
  # Set Time.now to September 1, 2008 10:05:00 AM (at this instant), but allow it to move forward
  t = Time.local(2008, 9, 1, 10, 5, 0)
  Timecop.travel(t)
end