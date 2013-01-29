source :rubygems

gem 'rails', '3.2.11'

gem 'pg'
gem 'yajl-ruby'
gem 'will_paginate', '~> 3.0'
gem "acts-as-taggable-on"
gem "newrelic_rpm"
gem "newrelic-redis", "1.3.2"
gem 'juggernaut', '2.1.1'
gem 'exceptional', '2.0.33'
gem 'subdomain-fu', :git => "git://github.com/nhowell/subdomain-fu.git"
gem 'thinking-sphinx', '2.0.13'
gem 'gravtastic'
gem 'ranked-model'
gem "hiredis", "0.4.5"
gem "redis", "3.0.2", :require => ["redis/connection/hiredis", "redis"]
gem 'thin'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bootstrap-sass', '~> 2.2.2.0'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'asset_sync'
end

group :development do
  gem 'debugger'
  gem 'ruby-prof'
  gem 'capistrano'
  gem 'capistrano-ext'
end

group :test do
  gem 'simplecov', '0.7.1', :require => false
  gem 'simplecov-console', :require => false
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem "rspec-rails", '2.12.1'
  gem "machinist"
  gem "faker"
  gem "timecop"
end
