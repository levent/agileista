set :stages, %w(production)
set :default_stage, "production"

require 'capistrano/ext/multistage'
require "bundler/capistrano"
