source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.8'

gem 'pg'
gem 'yajl-ruby'
gem 'will_paginate', '~> 3.0'
gem 'newrelic_rpm'
gem 'newrelic-redis'
gem 'tire'
gem 'gravtastic'
gem 'ranked-model'
gem 'hiredis', '0.4.5'
gem 'redis', require: ['redis/connection/hiredis', 'redis']
gem 'simple_form'
gem 'devise'
gem 'unicorn'
gem 'rack-timeout'
gem 'sidekiq'
gem 'sidetiq'
# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', '>= 1.3.0', require: nil
gem 'hipchat'
gem 'slack-notifier'
gem "sentry-raven"

gem 'sass-rails',   '~> 4.0.3'

gem 'foundation-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'protected_attributes'

gem 'turbolinks'


group :development do
  gem 'rails_best_practices'
  gem 'byebug'
  gem 'ruby-prof'
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'brakeman', :require => false
  gem 'dotenv-rails'
  gem 'rack-mini-profiler'
  gem 'flamegraph'

  gem 'uglifier', '>= 1.3.0'
end

group :test do
  gem 'simplecov', '0.7.1', require: false
  gem 'simplecov-console', require: false
  gem 'jshintrb'
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem 'rspec-rails'
  gem 'machinist'
  gem 'faker'
  gem 'timecop'
  gem 'rspec-fire'
end
