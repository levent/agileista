ActiveRecord::Base
# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Enable the breakpoint server that script/breakpointer connects to
# config.breakpoint_server = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
# config.action_view.cache_template_extensions         = false
config.action_view.debug_rjs                         = true
config.action_controller.session = {
  :key => '_fcloud_dev_session',
  :secret      => '3db594b389adf2e6b07ca41349e1dd55984f0ac7a3de3647220d6d44b97b720614714aaf24ef81aaf07b60418d262af93e26b73733102d6bdd126ab45c299baa',
  :expire_after => 24.hours
}
ActionController::Base.session_options[:session_domain] = 'agileista.local'

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

EMAIL_FROM = "donotreply@agileista.purebreeze.com"
