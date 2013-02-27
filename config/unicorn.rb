# config/unicorn.rb
worker_processes 3
timeout 15
preload_app true

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  defined?(REDIS) and
    REDIS.quit and
    Rails.logger.warn('redis quit')
end  

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  defined?(Redis) and
    REDIS = Redis.new(:host => 'localhost', :port => 6379) and
    Rails.logger.warn('redis connected')
end
