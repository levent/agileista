require 'resque'
REDIS = Redis.new(:host => 'localhost', :port => 6379)
Resque.redis = REDIS
