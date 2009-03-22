set :stages, %w(staging production)
set :default_stage, "staging"
set :keep_releases, 5
require 'capistrano/ext/multistage'