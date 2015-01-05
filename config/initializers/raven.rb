require 'raven'

Raven.configure do |config|
  config.dsn = 'https://e917e3ce50b0490caa302b32d07f2a53:32ad3807ab1f4f5aaa9ac50c58b710dc@app.getsentry.com/17262'
  config.environments = %w[ production ]
end
