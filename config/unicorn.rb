# config/unicorn.rb
worker_processes 6
timeout 15
preload_app true
pid "/u/apps/agileista.com/shared/pids/unicorn.pid"
listen "/tmp/unicorn.sock"
stderr_path "/u/apps/agileista.com/shared/log/unicorn.stderr.log"
stdout_path "/u/apps/agileista.com/shared/log/unicorn.stdout.log"

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  if defined?(Resque)
    Resque.redis.quit
    Redis.current.quit
    Rails.logger.info('Disconnected from Redis')
  end
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  if defined?(Resque)
    redis = Redis.new
    Resque.redis = redis
    Redis.current = redis
    Rails.logger.info('Connected to Redis')
  end
end
