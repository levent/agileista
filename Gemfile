source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails', '4.2.0'

gem 'pg'
gem 'yajl-ruby'
gem 'will_paginate', '~> 3.0'
gem 'newrelic_rpm'
gem 'newrelic-redis'
gem 'tire'
gem 'gravtastic'
gem 'ranked-model'
gem 'hiredis', '~> 0.5.0'
gem 'redis', require: ['redis/connection/hiredis', 'redis']
gem 'simple_form', '~> 3.0.3'
gem 'devise'
gem 'doorkeeper'
gem 'unicorn'
gem 'rack-timeout'
gem 'sidekiq'
gem 'sidetiq'
# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', '>= 1.3.0', require: nil
gem 'hipchat'
gem 'slack-notifier'
gem "sentry-raven"

gem 'sass-rails',   '~> 4.0.5'

gem 'foundation-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'turbolinks'
gem 'figaro'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'rails_best_practices'
  gem 'ruby-prof'
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'brakeman', :require => false
  gem 'rack-mini-profiler'
  gem 'flamegraph'

  gem 'uglifier', '>= 1.3.0'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'simplecov', '0.7.1', require: false
  gem 'simplecov-console', require: false
  gem 'jshintrb'
  gem 'shoulda-matchers'
  gem 'machinist'
  gem 'timecop'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'faker'
end
