# config/initializers/middleware.rb
require "rack/bug"

ActionController::Dispatcher.middleware.use Rack::Bug,
  :ip_masks   => [IPAddr.new("127.0.0.1")],
  :secret_key => "eR9dloOeAPepT5uCIchlsHCG66PtHd9K8l0q9avitiaA/KUrY72hDDE54yWY+8z1",
  :password   => "istanbul"
