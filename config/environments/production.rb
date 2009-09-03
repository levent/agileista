ActiveRecord::Base
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
ActionController::Base.session_options[:session_domain] = 'agileista.com'
config.action_controller.session = {
  :key => '_agileista_session',
  :secret      => '7220d6d42e6b07ca41349e1dd58d262af93e26b73733102d6bdd126ab45c299baa59844b97b720614714aaf24ef81aaf07b60413db594b389adff0ac7a3de364',
  :expire_after => 24.hours
}

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :enable_starttls_auto => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "agileista.com",
  :authentication => :plain,
  :user_name => "donotreply@agileista.com",
  :password => "xxxxxxxx"
}

EMAIL_FROM = "donotreply@agileista.com"

config.gem 'smtp_tls'