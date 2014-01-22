source 'https://rubygems.org'

gem 'rails', '3.2.16'

gem 'pg'
gem 'yajl-ruby'
gem 'will_paginate', '~> 3.0'
gem 'newrelic_rpm'
gem 'newrelic-redis'
gem 'tire'
gem 'gravtastic'
gem 'ranked-model'
gem 'hiredis', '0.4.5'
gem 'redis', :require => ['redis/connection/hiredis', 'redis']
gem 'simple_form', :git => 'https://github.com/plataformatec/simple_form.git', :branch => 'v2.1'
gem 'devise'
gem 'unicorn'
gem 'rack-timeout'
gem 'sidekiq'
# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'hipchat'
gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'compass-rails'
  gem 'zurb-foundation'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'asset_sync'
end

group :development do
  gem 'rails_best_practices'
  gem 'byebug'
  gem 'ruby-prof'
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'sextant'
  gem 'brakeman', :require => false
  gem 'dotenv-rails'
end

group :test do
  gem 'simplecov', '0.7.1', :require => false
  gem 'simplecov-console', :require => false
  gem 'jshintrb'
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem 'rspec-rails'
  gem 'machinist'
  gem 'faker'
  gem 'timecop'
  gem 'rspec-fire'
end
