require 'raven'

Raven.configure do |config|
  config.dsn = ENV['raven_dsn']
  config.environments = %w[ production ]
end
