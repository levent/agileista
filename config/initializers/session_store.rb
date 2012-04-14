# Be sure to restart your server when you modify this file.

Agileista::Application.config.session_store :cookie_store,
  :key => '_agileista_session',
  :domain => COOKIE_DOMAIN

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Agileista::Application.config.session_store :active_record_store
