# ENV['GEM_PATH'] = '/home/levental/gems:/usr/lib/ruby/gems/1.8'
# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'
# ENV['GEM_PATH']='/home/levent/.gem/ruby/1.8:/usr/lib/ruby/gems/1.8' if ENV['RAILS_ENV'] == 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store
  config.action_controller.session = {
    :key => '_fcloud_session',
    :secret      => '59844b97b720614714aaf24ef81aaf07b60413db594b389adff0ac7a3de3647220d6d42e6b07ca41349e1dd58d262af93e26b73733102d6bdd126ab45c299baa'
  }

  config.time_zone = 'UTC'

  config.action_mailer.raise_delivery_errors = true
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
  # The gems required by this application
  # config.gem "pdf-writer", :lib => "pdf/writer"
  # config.gem "color-tools", :lib => "color"
  config.gem "fastercsv"
  config.gem "json"
  config.gem "prawn"
  config.gem 'mislav-will_paginate', :version => '~> 2.3.6', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'haml'

  config.gem "newrelic_rpm"
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
ActionMailer::Base.delivery_method = :sendmail

ActionMailer::Base.sendmail_settings = {
:location       => '/usr/sbin/sendmail',
:arguments      => '-i -t'
}
#ActionMailer::Base.perform_deliveries = true
#ActionMailer::Base.raise_delivery_errors = true
#ActionMailer::Base.server_settings = {
#  :address        => "agileista.leventali.com", 
#  :port           => 25, 
#  :user_name      => "levental", 
#  :password       => "xxxxxxxx", 
#  :authentication => :login 
#}
# ExceptionNotifier.exception_recipients = %w(levent@leventali.com)
# ExceptionNotifier.sender_address = %("Agileista Exception" <exception@agileista.purebreeze.com>)
PEOPLE_SALT = 'somecrazyrandomstring'
SubdomainFu.tld_sizes = {:development => 1,
                         :test => 0,
                         :staging => 1,
                         :production => 1}
SubdomainFu.mirrors = %w(app) if Rails.env == "staging"
# SubdomainFu.preferred_mirror = "app"