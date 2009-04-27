# config/initializers/middleware.rb
require "rack/bug"

ActionController::Dispatcher.middleware.use Rack::Bug,
  :ip_masks   => ["127.0.0.1", "78.105.104.131"].map {|ip| IPAddr.new(ip)},
  :secret_key => "8z-jTR?/*K<y:re}qnRvk[EZQTTZV|JMc-uv{PSjY`_6SP<y!2E}&AN-UW5p95zc",
  :password   => "bu993er0ff"